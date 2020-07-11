import controlP5.*;
ControlP5 cp5;

// INITIAL SETTINGS
int numArmParts = 2;
float [] ks = {2.5,10,300};
float [] armLengths = {50,80,70};
float [] masses = {100,200,1000};
float [] pumpForces = { 4, 4, 0 };
float [] dampeners = {.999, .999, .999};
float [] angleOffParent = {-35, 35, 25 };
float [] flapForces = {0,0,0};
Slider kValueSlider, massSlider, forearmLenSlider;
RadioButton armPartChoice;

ArmPart[] armParts;

// see: https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/
float angleBetweenVectors(PVector v1, PVector v2) {
  PVector zeroCheck = PVector.sub(v1,v2);
  if (zeroCheck.mag() < 0.01) {
    return 0;
  }
  float dp = v1.dot(v2);
  float denom = v1.mag() * v2.mag();
  float angle = acos(dp/denom);
  return degrees(angle);
}

// https://forum.processing.org/two/discussion/3811/what-is-the-alternative-in-processing
int sign(float f) {
  if(f==0) return(0);
  return(int(f/abs(f)));
}

void flap(float[] forces) {
  for (int i = 0; i < numArmParts; ++i) {
    armParts[i].reset();
    armParts[i].applyTangentialForce(forces[i]);
  }
}

void keyPressed() {
  float divisor = 10;
  float pulse = (mouseY / divisor) ;
  float forceAmts[] = {pulse, pulse * .75, 0};
  flap(forceAmts);
}

void setupControls() {
  cp5 = new ControlP5(this);
  kValueSlider = cp5.addSlider("k-value")
     .setPosition(50,height - 80)
     .setSize(300,20)
     .setRange(0,300)
     .setValue(ks[1]);
  massSlider = cp5.addSlider("mass")
     .setPosition(50,height - 55)
     .setSize(300,20)
     .setRange(0,2000)
     .setValue(200);
  forearmLenSlider = cp5.addSlider("forearmLength")
     .setPosition(50,height - 30)
     .setSize(300,20)
     .setRange(0,300)
     .setValue(80);
  armPartChoice = cp5.addRadioButton("partChoice")
     .setPosition(50, height - 120)
     .setSize(40,20)
     .setColorForeground(color(50))
     .setColorActive(color(0))
     .setColorLabel(color(100))
     .setItemsPerRow(3)
     .setSpacingColumn(75)
     .addItem("Shoulder",0)
     .addItem("Forearm",1)
     .addItem("Hand",2)
     ;
     
   for(Toggle t:armPartChoice.getItems()) {
     t.getCaptionLabel().setColorBackground(color(255,80));
     t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
     t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
     t.getCaptionLabel().getStyle().backgroundWidth = 45;
     t.getCaptionLabel().getStyle().backgroundHeight = 13;
   }
   
   armPartChoice.activate(1);
}


void setup() {
  size(500,500);
  PVector anchor = new PVector(0,0);
  armParts = new ArmPart[numArmParts];
  for (int i = 0; i < numArmParts; ++i) {
    armParts[i] = new ArmPart(i, 
                              (i == 0 ? null : armParts[i-1]),
                              (i == 0 ? anchor : armParts[i-1].getArmEnd()),
                              armLengths[i],
                              ks[i],
                              pumpForces[i],
                              dampeners[i],
                              0.8,
                              4,
                              masses[i],
                              angleOffParent[i]);
    armParts[i].setApplySpringForce(true);
    armParts[i].setApplyGravity(false);
  }
  
  setupControls();
}


// DRAW FUNCTION
void draw() {
                    
  // DRAW SPRING-MASS

  background(255, 255, 255);
  color(0);
  stroke(0);
  
  pushMatrix();
  translate(width/4,height/2);
  int i = 0;
  while (i < numArmParts) {
    armParts[i].update();
    armParts[i].render();
    i = i + 1;
  }
  popMatrix();
  
  fill(0);
  text("kVal:", 10, height - 65);
  text("mass:", 10, height - 40);
  text("faLen:",10, height - 15);
  
  int whichArmPart = (int) armPartChoice.getValue();
  armParts[whichArmPart].setKVal(kValueSlider.getValue()); //<>//
  armParts[whichArmPart].setMass(massSlider.getValue());
  armParts[whichArmPart].setLength(forearmLenSlider.getValue());
 
};
