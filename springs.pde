// INITIAL SETTINGS
float mass;
float k;
float dampener;
PVector anchor, particlePrev, particleNext;
float armLength;
PVector particle, particleVel, vecToCenter, springAxis, springForceVector;
ArmPart[] armParts;

// see: https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/
float angleBetweenVectors(PVector v1, PVector v2) {
  float dp = v1.dot(v2);
  float denom = v1.mag() * v2.mag();
  float angle = acos(dp/denom);
  return degrees(angle);
}

void setup() {
  size(500,500);
  mass = 1000;
  anchor = new PVector(width / 2, height / 2);
  k = 2;
  dampener = 0.995;
  armLength = 100;
  armParts = new ArmPart[2];
  armParts[0] = new ArmPart(anchor, armLength, k, dampener, 1000);
  //particlePrev = new PVector(anchor.x + armLength, anchor.y);
  //particleNext = new PVector(0,0);
  //vecToCenter = new PVector(0,0);
  //particleVel = new PVector(0,-10);
  //springAxis = new PVector(1,0);
  //springForceVector = new PVector(0,0);
}

// DRAW FUNCTION
void draw() {
                    
  // DRAW SPRING-MASS
  color(0);
  stroke(0);
  background(255, 255, 255);
  
  armParts[0].update();
  armParts[0].render();
  
  
};
