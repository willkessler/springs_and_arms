// INITIAL SETTINGS
int numArmParts = 1;
float [] ks = {1.5,55,2000};
float [] armLengths = {80,80,70};
float [] masses = {100,100,2000};
float [] dampeners = {.999, .99, .99};
float [] angleOffParent = {-35, 35, 25 };
float [] flapForces = {0,2000,2000};

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

void mousePressed() {
  float divisor = 10;
  float pulse = (mouseY / divisor) ;
  float forceAmts[] = {pulse, pulse, 0};
  flap(forceAmts);
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
                              75,
                              dampeners[i],
                              0.35,
                              4,
                              masses[i],
                              angleOffParent[i]);
    armParts[i].setApplySpringForce(true);
    armParts[i].setApplyGravity(false);
  }
  flap(flapForces);
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
