import controlP5.*;
ControlP5 cp5;

// INITIAL SETTINGS
int numArmParts = 3;
float [] ks = {2.5,10,300};
float [] armLengths = {50,80,70};
float [] masses = {100,200,1000};
float [] pumpForces = { 4, 4, 0 };
float [] dampeners = {.999, .999, .999};
float [] angleOffParent = {-35, 35, 25 };
float [] flapForces = {0,0,0};
Slider [] kValueSliders, massSliders, forearmLenSliders;
Slider pulseStrengthSlider;
CheckBox continuousPulseCheckbox;

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
  kValueSliders = new Slider[numArmParts];
  massSliders = new Slider[numArmParts];
  forearmLenSliders = new Slider[numArmParts];
  for (int i = 0; i < numArmParts; ++i) {
    kValueSliders[i] = cp5.addSlider("k-value-" + i)
     .setPosition(70,height - ((100 * i) + 75))
     .setSize(300,20)
     .setRange(0,300)
     .setValue(ks[i]);
    massSliders[i] = cp5.addSlider("mass-" + i)
     .setPosition(70,height - ((100 * i) + 50))
     .setSize(300,20)
     .setRange(0,2000)
     .setValue(masses[i]);
   forearmLenSliders[i] = cp5.addSlider("forearmLength-" + i)
     .setPosition(70,height - ((100 * i) + 25))
     .setSize(300,20)
     .setRange(0,300)
     .setValue(armLengths[i]);
  }
  continuousPulseCheckbox = cp5.addCheckBox("Pulse")
                .setPosition(50, 50)
                .setSize(10, 10)
                .setItemsPerRow(1)
                .setSpacingColumn(30)
                .setSpacingRow(20)
                .addItem("Continous Pulse", 1)
                .setColorLabel(50)
                ;
  continuousPulseCheckbox.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(10);
}


void setup() {
  size(1000,500);
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
  translate(width/2,height/2);
  int i = 0;
  while (i < numArmParts) {
    armParts[i].update();
    armParts[i].render();
    i = i + 1;
  }
  popMatrix();
  
  fill(0);
  
  i = 0;
  while (i < numArmParts) {
    text("kVal-" + i + ":",  10, height - ((100 * i) + 60));
    text("mass-" + i + ":",  10, height - ((100 * i) + 35));
    text("length-" + i + ":", 10, height - ((100 * i) + 10));
    armParts[i].setKVal(kValueSliders[i].getValue()); //<>//
    armParts[i].setMass(massSliders[i].getValue());
    armParts[i].setLength(forearmLenSliders[i].getValue());
    i++;
  }
  //text("Continuous pulse", 65,60); 
};
