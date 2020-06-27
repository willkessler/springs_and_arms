// INITIAL SETTINGS
float gravity = 30;
float mass = 250;
float anchorX , anchorY, positionX, positionY;
float angle, radAngle, angularVel, angularAccel, angularForce;
float k;
float armLength;

void setup() {
  size(500,500);
  anchorX = width / 8;
  anchorY = height / 2;
  k = 10;
  angle = 45;
  angularVel = 0;
  angularAccel = 10;
  armLength = 100;
}

// DRAW FUNCTION
void draw() {

    // FORCE CALCULATIONS
    angularForce = -k * angle;
    angularAccel = angularForce / mass;
    angularVel += angularAccel;
    angle += angularVel;
    radAngle = radians(angle);
    positionX = cos(radAngle) * armLength + anchorX;
    positionY = sin(radAngle) * armLength + anchorY;
                    
    // DRAW SPRING-MASS
    color(0);
    stroke(0);
    background(255, 255, 255);
    rect(anchorX - 5, anchorY - 5, 10, 10);
    line(anchorX,anchorY, positionX, positionY);
    ellipse(positionX, positionY, 10, 10);

};
