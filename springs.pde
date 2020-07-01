// INITIAL SETTINGS
float [] ks = {1.5,10,7};
float [] armLengths = {80,80,70};
float [] masses = {1000,20,20};
float [] dampeners = {0.99, .5, .5};
ArmPart[] armParts;
int numArmParts = 3;

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

void flap() {
  armParts[0].applyAngularVelocity(-5);
  //armParts[1].applyAngularVelocity(0);
  //armParts[2].applyAngularVelocity(10);
}

void setup() {
  size(1000,500);
  PVector anchor = new PVector(0,0);
  armParts = new ArmPart[numArmParts];
  armParts[0] = new ArmPart(0, null,        anchor,                   armLengths[0], ks[0], dampeners[0], masses[0], -35);
  armParts[1] = new ArmPart(1, armParts[0], armParts[0].getArmEnd(),  armLengths[1], ks[1], dampeners[1], masses[1], -35);
  armParts[2] = new ArmPart(2, armParts[1], armParts[1].getArmEnd(),  armLengths[2], ks[2], dampeners[2], masses[2], -15);
  armParts[1].setApplySpringForce(false);
  armParts[2].setApplySpringForce(false);
  flap();
}

void mousePressed() {
  flap();
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
  
};
