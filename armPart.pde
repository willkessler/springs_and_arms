class ArmPart {
  PVector anchor, armPrevEnd, armNextEnd;
  PVector armVector, armVel, springAxis, vecToAnchor, springForceVector;
  float armLength;
  float mass;
  float k;
  float dampener;
  
  ArmPart(PVector anc, float al, float kVal, float dampenerVal, float m ) {
    mass = m;
    anchor = new PVector(width / 2, height / 2);
    k = kVal;
    armLength = al;
    dampener = dampenerVal;
    
    anchor = new PVector(anc.x, anc.y);
    vecToAnchor = new PVector(0,0);
    armNextEnd = new PVector(0,0);
    armPrevEnd = new PVector(anchor.x, anchor.y + armLength);
    armVector = new PVector(0,0);
    armVel = new PVector(0,-10);
    springAxis = new PVector(1,0);
    springForceVector = new PVector(0,0);  
  }
  
  void update() {
    // Put a particle in motion
    armNextEnd.set(armPrevEnd);
    armNextEnd.add(armVel);
    vecToAnchor.set(armNextEnd.x - anchor.x, armNextEnd.y - anchor.y);
    vecToAnchor.normalize();
    
    float angleToXAxis = -atan2(vecToAnchor.y, vecToAnchor.x);
    float springForce = -k * angleToXAxis;
    float springAccel = springForce / mass; // radial acceleration caused by spring
    // spring force acceleration vector is tangential to unit circle at current angle, or, opposite current velocity vector
    springForceVector.set(vecToAnchor);
    springForceVector.rotate(radians(-90));
    springForceVector.mult(springAccel);
    vecToAnchor.add(springForceVector);
    //println(degrees(angleToXAxis), springAccel);
    
    vecToAnchor.mult(armLength);
    
    armNextEnd.set(anchor.x + vecToAnchor.x, anchor.y + vecToAnchor.y);
    
    armVel.set(armNextEnd.x - armPrevEnd.x, armNextEnd.y - armPrevEnd.y);
    armPrevEnd.set(armNextEnd);
    armVel.mult(dampener);
  }
  
  void render() {
   // DRAW SPRING-MASS
    rect(anchor.x - 5, anchor.y - 5, 10, 10);
    line(anchor.x, anchor.y, armNextEnd.x, armNextEnd.y);
    ellipse(armNextEnd.x, armNextEnd.y,10,10);
  }
  
}
