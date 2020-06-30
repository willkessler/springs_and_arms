// INITIAL SETTINGS
float [] ks = {2,4,8};
float [] armLengths = {80,50,30};
float [] masses = {1000,1000,1000};
ArmPart[] armParts;
int felix = 5;

// see: https://www.euclideanspace.com/maths/algebra/vectors/angleBetween/
float angleBetweenVectors(PVector v1, PVector v2) {
  float dp = v1.dot(v2);
  float denom = v1.mag() * v2.mag();
  float angle = acos(dp/denom);
  return degrees(angle);
}

void setup() {
  size(1000,500);
  PVector anchor = new PVector(0,0);
  float dampener = .996;
  armParts = new ArmPart[3];
  armParts[0] = new ArmPart(null,        anchor,                   armLengths[0], ks[0], dampener, masses[0]);
  armParts[1] = new ArmPart(armParts[0], armParts[0].getArmEnd(),  armLengths[1], ks[1], dampener, masses[1]);
  armParts[2] = new ArmPart(armParts[1], armParts[1].getArmEnd(),  armLengths[2], ks[2], dampener, masses[2]);
  armParts[0].applyVelocity(new PVector(0,-5));
  armParts[1].applyVelocity(new PVector(0,-7));
  armParts[2].applyVelocity(new PVector(0,-5));

felix = 6;
  println(felix);
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
  while (i < 3) {
    armParts[i].update();
    armParts[i].render();
    i = i + 1;
  }
  popMatrix();
  
};
