class ArmPart {
  PVector anchor, armPrevEnd, armNextEnd, parentArmEnd;
  PVector armVector, armVel, springAxis, springForceVector, tangentialAccelVector;
  PVector gravityVector;
  float armLength;
  float mass;
  float k;
  float dampener;
  float highDampener;
  float angleOffParent;
  float pumpForce;
  int pumpForceInc;
  int armId;
  int cycleCount;
  int requestedCycles;
  float lastSignOfForce;
  ArmPart parent;
  boolean applySpringForce;
  boolean applyGravity;
  float gravityForce = .005;
  
  ArmPart(int id, ArmPart p, PVector anc, float al, float kVal, float pf, float dampenerVal, float highDampenerVal, 
          int requestedCyclesVal, float m, float angleOffParentVal ) {
    parent = p;
    mass = m;
    k = kVal;
    armLength = al;
    dampener = dampenerVal;
    highDampener = highDampenerVal;
    pumpForce = pf;
    requestedCycles = requestedCyclesVal * 2 ; // full cycle passes the spring axis twice
    armId = id;
    cycleCount = 0;
    lastSignOfForce = -2;
    angleOffParent = angleOffParentVal;
    anchor = new PVector(anc.x, anc.y);
    
    applySpringForce = true;
    applyGravity = true;
    gravityVector = new PVector(0,gravityForce);
    reset();

  }
  
  PVector getArmEnd() {
    return armNextEnd;
  }
  
  PVector getArmVector() {
     PVector armVec = new PVector(armNextEnd.x - anchor.x, armNextEnd.y - anchor.y);
     armVec.normalize();
     return armVec;
  }
  
  void setApplyGravity(boolean newVal) {
    applyGravity = newVal;
  }
  
  void setApplySpringForce(boolean newVal) {
    applySpringForce = newVal;
  }
  
  void reset() {
    springAxis = new PVector(1,0);
    if (parent != null) {
      springAxis = parent.getArmVector();
    }
    springAxis.rotate(radians(angleOffParent));
    PVector initialArmVector = new PVector(springAxis.x, springAxis.y);
    initialArmVector.mult(armLength);
    armPrevEnd = new PVector(anchor.x + initialArmVector.x, anchor.y + initialArmVector.y );
    armNextEnd = new PVector(anchor.x + initialArmVector.x, anchor.y + initialArmVector.y );
  
    armVector = new PVector(0,0);
    armVel = new PVector(0,0);
    springForceVector = new PVector(0,0);
    tangentialAccelVector = new PVector(0,0);
    cycleCount = 0;
    lastSignOfForce = -2;
    pumpForceInc = -1;
    armVel.set(0,0); // reset arm velocity
 }
  
  // accel = force / m
  void applyTangentialForce(float force) {
    tangentialAccelVector = getArmVector();
    float acceleration = force / mass;
    tangentialAccelVector.rotate(radians(90));
    tangentialAccelVector.mult(acceleration);
  }
  
  void update() {    
    if (parent != null) {
      parentArmEnd = parent.getArmEnd();
      anchor.set(parentArmEnd.x, parentArmEnd.y);
    }
    armNextEnd.set(armPrevEnd);
    armNextEnd.add(armVel);
    armVector = getArmVector();
 
    boolean pumpTheArm = (cycleCount < requestedCycles);
    
    float angleToSpringAxis = angleBetweenVectors(springAxis, armVector);
    //println("angleToSpringAxis", angleToSpringAxis);
    if (applySpringForce) {
      //float angleToXAxis = -atan2(armVector.y, armVector.x);
      // cross prod of 2 2d vecs, cf source of https://chipmunk-physics.net/
      // also see https://stackoverflow.com/questions/243945/calculating-a-2d-vectors-cross-product#:~:text=You%20can't%20do%20a,vectors%20on%20the%20xy%2Dplane.
      float signOfForce = springAxis.x * armVector.y - springAxis.y * armVector.x;
      //println(lastSignOfForce, signOfForce, cycleCount);
      if ((lastSignOfForce != -2) && (sign(signOfForce) != sign(lastSignOfForce))) {
        ++cycleCount;
      }
      lastSignOfForce = signOfForce;
      float springForce = signOfForce * k * radians(angleToSpringAxis);
      float springAccel = springForce / mass; // radial acceleration caused by spring
      // spring force acceleration vector is tangential to unit circle at current angle, or, opposite current velocity vector
      springForceVector.set(armVector);
      springForceVector.rotate(radians(-90));
      springForceVector.mult(springAccel);
      armVector.add(springForceVector);
      //println(degrees(angleToXAxis), springAccel);
    }
    
    if (applyGravity) {
      armVector.add(gravityVector);
    }
    
    
    armVector.add(tangentialAccelVector);
    tangentialAccelVector.set(0,0);
    
    armVector.normalize();
    armVector.mult(armLength);
    
    armNextEnd.set(anchor.x + armVector.x, anchor.y + armVector.y);
    
    float armVelYCheck = armVel.y;
    armVel.set(armNextEnd.x - armPrevEnd.x, armNextEnd.y - armPrevEnd.y);
    if ((sign(armVelYCheck) == -1) && (sign(armVel.y) == 1) && pumpTheArm) {
      pumpForceInc = 0;
    }
    
    if (pumpForceInc > -1) {
      applyTangentialForce(sin(radians(pumpForceInc)) * pumpForce);
      pumpForceInc+= 30;
      if (pumpForceInc >= 180) {
        pumpForceInc = -1;
      }
    }

    armPrevEnd.set(armNextEnd);
    float appliedDampener = (pumpTheArm ? dampener : highDampener);
    //println("armVel", armVel, "cycleCount", cycleCount, "appliedDampener",  appliedDampener); 
    armVel.mult(appliedDampener);
    
  }
  
  void render() {
   // DRAW SPRING-MASS
    rect(anchor.x - 5, anchor.y - 5, 10, 10);
    line(anchor.x, anchor.y, armNextEnd.x, armNextEnd.y);
    ellipse(armNextEnd.x, armNextEnd.y,10,10);
  }
  
}
