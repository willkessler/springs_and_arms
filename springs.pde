// TODO
// X Calculate lift and drag forces for each wing section and display them
// Make the pump force use a bump wave fn and vary its amplitude and peak position to optimize lift
// Vary the pump start time


import controlP5.*;
ControlP5 cp5;

// INITIAL SETTINGS
int numArmParts = 3;
float [] ks = {6,9,25};
float [] armLengths = {85,134,70};
float [] armWidths = {10,8,4};
float [] masses = {486.66,593.33,1000};
float [] pumpForces = { 10, 4, 0.83 };
float [] dampeners = {.999, .999, .999};
float [] angleOffParent = {-35, 35, 25 };
Slider [] kValueSliders, massSliders, forearmLenSliders, pumpSliders;
Slider pulseStrengthSlider;
Toggle continuousPulseToggle;
boolean continuousPulse;

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

void applyFirstPumps() {
  for (int i = 0; i < numArmParts; ++i) {
    armParts[i].reset();
    armParts[i].applyTangentialForce(pumpForces[i]);
  }
}

void keyPressed() {
  if (key == ' ') {
    float divisor = 10;
    float pulse = (mouseY / divisor) ;
    float forceAmts[] = {pulse, pulse * .75, 0};
    flap(forceAmts);
  }
}

void setupControls() {
  cp5 = new ControlP5(this);
  kValueSliders = new Slider[numArmParts];
  massSliders = new Slider[numArmParts];
  forearmLenSliders = new Slider[numArmParts];
  pumpSliders = new Slider[numArmParts];
  int j;
  for (int i = 0; i < numArmParts; ++i) {
    j = numArmParts - i - 1;
    kValueSliders[i] = cp5.addSlider("k-value-" + j)
     .setPosition(10,height - ((100 * i) + 100))
     .setSize(300,20)
     .setRange(0,300)
     .setValue(ks[j]);
    massSliders[i] = cp5.addSlider("mass-"  + j)
     .setPosition(10,height - ((100 * i) + 75))
     .setSize(300,20)
     .setRange(0,2000)
     .setValue(masses[j]);
   forearmLenSliders[i] = cp5.addSlider("forearmLength-" + j)
     .setPosition(10,height - ((100 * i) + 50))
     .setSize(300,20)
     .setRange(0,300)
     .setValue(armLengths[j]);
    pumpSliders[i] = cp5.addSlider("pumpSlider-" + j)
     .setPosition(10,height - ((100 * i) + 25))
     .setSize(300,20)
     .setRange(0,50)
     .setValue(pumpForces[j]);
  }
  // https://www.kasperkamperman.com/blog/processing-code/controlp5-library-example1/
  // parameters : name, default value (boolean), x, y, width, height
  continuousPulseToggle = cp5.addToggle("Pulse", true, 50, 50, 10, 10);
  continuousPulseToggle.setLabel("Continous Pump").setColorValue(0xffff8800) ;
 
  continuousPulseToggle.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(10);
}


void setup() {
  size(1000,500);
  PVector anchor = new PVector(0,0);
  armParts = new ArmPart[numArmParts];
  continuousPulse = true;
  for (int i = 0; i < numArmParts; ++i) {
    armParts[i] = new ArmPart(i, 
                              (i == 0 ? null : armParts[i-1]),
                              (i == 0 ? anchor : armParts[i-1].getArmEnd()),
                              armLengths[i],
                              armWidths[i],
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
  applyFirstPumps();
}


// DRAW FUNCTION
void draw() {
                    
  // DRAW SPRING-MASS

  background(125, 125, 125);
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
  int j;
  float [] lifts = new float[numArmParts];
  float totalLift = 0;
  int liftDisplayX = 200;

  for (i = 0; i < numArmParts; ++i) {
    j = numArmParts - i - 1;
    /*text("kVal-" + j + ":",  10, height - ((100 * j) + 85));
    text("mass-" + j + ":",  10, height - ((100 * j) + 60));
    text("length-" + j + ":", 10, height - ((100 * j) + 35));
    text("pump-" + j + ":", 10, height - ((100 * j) + 10));*/
    armParts[i].setKVal(kValueSliders[j].getValue());
    armParts[i].setMass(massSliders[j].getValue());
    armParts[i].setLength(forearmLenSliders[j].getValue());
    armParts[i].setPumpForce(pumpSliders[j].getValue());   
    lifts[i] = armParts[i].computeLift();
    totalLift += lifts[i];
    text(round(lifts[i]), width - liftDisplayX + ((i + 1) * 40), height - 10);
  }
  continuousPulse = continuousPulseToggle.getState();
  text("Lift:", width - liftDisplayX - 25, height - 10);
  text(round(totalLift), width - liftDisplayX, height - 10);

  println("lift", lifts[0], lifts[1], lifts[2], totalLift);
  
};
