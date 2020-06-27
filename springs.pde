// INITIAL SETTINGS
float gravity = 30;
float mass = 150;
float positionX, positionY;
float velocityY = 0;
float timeStep;
float upTimeStep = 0.2;
float downTimeStep = upTimeStep * 2.05;
float anchorX , anchorY;
float k = 18;
float minY, maxY;
boolean stabilized;

void setup() {
  size(500,500);
  anchorX = width / 2;
  anchorY = height / 4;
  positionX = anchorX;
  positionY = anchorY +25;
  minY = 100000;
  maxY = -100000;
}

// DRAW FUNCTION
void draw() {
    // FORCE CALCULATIONS
    
     float springForceY = -k*(positionY - anchorY);
     float forceY = springForceY + mass * gravity;
     float accelerationY = forceY/mass;
     timeStep = upTimeStep;
     if (velocityY > 0) {
       timeStep = downTimeStep;
     }
     
     velocityY = velocityY + accelerationY * timeStep;
     positionY = positionY + velocityY * timeStep;
    
     stabilized = true; 
     if ((positionY > maxY) || (positionY < minY)) {
       stabilized = false;
     }
     maxY = max(positionY, maxY);
     minY = min(positionY, minY);
     
     // DRAW SPRING-MASS
     background(255, 255, 255);
     rect(anchorX-5, anchorY-5, 10, 10);
     color(0);
     stroke(0);
     
     line(anchorX, positionY, anchorX, anchorY);
     ellipse(anchorX, positionY, 20, 20);
    
     if (stabilized) {
       float mappedAngle = map(positionY,minY,maxY, -45,55);
       //println(angle, mappedAngle, minY, maxY);
       float positionX1 = (cos(radians(mappedAngle))) * 100 + anchorX;
       float positionY1 = (sin(radians(mappedAngle)) * 100) + anchorY;
       line(anchorX,anchorY, positionX1, positionY1);
       ellipse(positionX1, positionY1, 20, 20);
     }

};
