// INITIAL SETTINGS
float gravity;
float mass;
float k;
float dampener;
PVector anchor, particlePrev, particleNext;
float armLength;
PVector particle, particleVel, vecToCenter, springAxis, springForceVector;
Spring[] armParts;

// see: https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/
float angleBetweenVectors(PVector v1, PVector v2) {
  float dp = v1.dot(v2);
  float denom = v1.mag() * v2.mag();
  float angle = acos(dp/denom);
  return degrees(angle);
}

void setup() {
  size(500,500);
  gravity = 30;
  mass = 1000;
  anchor = new PVector(width / 2, height / 2);
  k = 2;
  dampener = 0.995;
  armLength = 100;
  armParts = new Spring[2];
  particlePrev = new PVector(anchor.x + armLength, anchor.y);
  particleNext = new PVector(0,0);
  vecToCenter = new PVector(0,0);
  particleVel = new PVector(0,-10);
  springAxis = new PVector(1,0);
  springForceVector = new PVector(0,0);
}

// DRAW FUNCTION
void draw() {

  // Put a particle in motion
  particleNext.set(particlePrev);
  particleNext.add(particleVel);
  vecToCenter.set(particleNext.x - anchor.x, particleNext.y - anchor.y);
  vecToCenter.normalize();
  
  float angleToXAxis = -atan2(vecToCenter.y, vecToCenter.x);
  float springForce = -k * angleToXAxis;
  float springAccel = springForce / mass; // radial acceleration caused by spring
  // spring force acceleration vector is tangential to unit circle at current angle, or, opposite current velocity vector
  springForceVector.set(vecToCenter);
  springForceVector.rotate(radians(-90));
  springForceVector.mult(springAccel);
  vecToCenter.add(springForceVector);
  //println(degrees(angleToXAxis), springAccel);
  
  vecToCenter.mult(armLength);
  
  particleNext.set(anchor.x + vecToCenter.x, anchor.y + vecToCenter.y);
  
  particleVel.set(particleNext.x - particlePrev.x, particleNext.y - particlePrev.y);
  particlePrev.set(particleNext);
  particleVel.mult(dampener);
                    
  // DRAW SPRING-MASS
  color(0);
  stroke(0);
  background(255, 255, 255);
  rect(anchor.x - 5, anchor.y - 5, 10, 10);
  line(anchor.x, anchor.y, particleNext.x, particleNext.y);
  ellipse(particleNext.x, particleNext.y,10,10);

};
