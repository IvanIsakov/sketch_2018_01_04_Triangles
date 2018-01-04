int index = 1;
boolean MouseBool = false;
ArrayList<Particle> particles = new ArrayList<Particle>();
int NextVersion = 1;
float velocityX;
float velocityY;  
float velocityAvg;
long timer;
float mouseEmulateX;
float mouseEmulateY;
int movementIndex = 0;

void setup() {
  size(1000, 900);
  background(0);
  //timer = millis();
}

void draw() {
  noStroke();
  int velocity;
  
  //mouseEmulate();

  
  if (MouseBool) {
    // If you want to follow the mouse
    velocityX = mouseX - pmouseX;
    velocityY = mouseY - pmouseY;
    // If you want to run away from the mouse:
    //velocityX = pmouseX - mouseX;
    //velocityY = pmouseY - mouseY;
    velocityAvg = sqrt(velocityX*velocityX + velocityY*velocityY);
    velocity = int(velocityAvg/2);
    //ellipse(mouseX,mouseY,velocity,velocity);
    for (int i = 0; i < velocity; i++) {
      Particle p = new Particle(mouseX,mouseY);
      //Particle p = new Particle(mouseEmulateX,mouseEmulateY);
      particles.add(p);
      p.speedX2 = random(-abs(velocityAvg), abs(velocityAvg));
      p.speedY2 = random(-abs(velocityAvg), abs(velocityAvg));
      p.speedX3 = random(-abs(velocityAvg), abs(velocityAvg));
      p.speedY3 = random(-abs(velocityAvg), abs(velocityAvg));
      p.colorB = int(random(255));
      p.colorC = int(random(255));
    }
  }
  
  if (particles.size() > 400) {
    int sizeNow = particles.size();
    for (int i = 0; i < sizeNow - 400; i++) {
      Particle B = particles.get(0);
      particles.remove(B);
    }
  }
  
  //background(0);
  for (Particle p : particles) {
    p.update();
    p.display();
  }
  println(particles.size());
  //saveFrame("Triangles-####.png");
}

class Particle {
  float speedX2;
  float speedY2;
  float speedX3;
  float speedY3;
  float posX;
  float posY;
  float posX2;
  float posY2;  
  float posX3;
  float posY3;
  float gravity = 0.1;
  float viscousCoeff = 0.3;
  boolean exist;
  PShape tria;
  int colorB;
  int colorC;
  
  Particle(float x, float y) {
    stroke(255);
    posX = x;
    posY = y;
    exist = true;
    posX2 = posX;
    posX3 = posX;
    posY2 = posY;
    posY3 = posY;
    // Initialize tail


  }
  
  void update() {
    // For viscous solution
    speedX2 -= (speedX2) * viscousCoeff ;
    speedY2 -= (speedY2) * viscousCoeff ;
    speedX3 -= (speedX3) * viscousCoeff ;
    speedY3 -= (speedY3) * viscousCoeff ;
    
    posX2 += speedX2;
    posY2 += speedY2;
    posX3 += speedX3;
    posY3 += speedY3;
  }
  
  void display() {
    //point(posX2,posY2);
    createShape();
    beginShape();
    fill(0,colorB,colorC,125);
    //stroke(255);
    noStroke();
    vertex(posX,posY);
    vertex(posX2,posY2);
    vertex(posX3,posY3);
    endShape();
    //shape(tria);
     }

}

void mousePressed() {
  MouseBool = true;
}

void mouseReleased() {
  MouseBool = false;
}

void keyPressed() {
  if (key == ' ') {
    saveFrame("Triangles-stills-####.png");
    //background(0);
    //particles = new ArrayList<Particle>();
    //NextVersion++;
    //if (NextVersion > 3) NextVersion = 1;
  }
}


void mouseEmulate() {
  float mouseEmulateXPrev = 0;
  float mouseEmulateYPrev = 0;
  float speed = 0.4;
  if (movementIndex == 0) {
    MouseBool = true;
    mouseEmulateX = (millis() - timer) * speed*0.4;
    mouseEmulateY = (millis() - timer) * speed*0.33;
    if (mouseEmulateX > width) {
      movementIndex++;
      timer = millis();
      MouseBool = false;
    }
  } else if (movementIndex == 1) {
    MouseBool = true;
    mouseEmulateX = width - ((millis() - timer) * speed*0.4);
    mouseEmulateY = (millis() - timer) * speed*0.33;
    if (mouseEmulateX < 0) {
      movementIndex++;
      timer = millis();
      MouseBool = false;
    }
  } else if (movementIndex == 2) {
    MouseBool = true;
    mouseEmulateX = width/2 + 400 * sin((millis() - timer) * 0.001 * speed);
    mouseEmulateY = height/2 + 400 * cos((millis() - timer) * 0.001 * speed);
    if (millis() > timer*3 ) {
      movementIndex++;
    }
  } else if (movementIndex == 3) {
    MouseBool = false;
  }
  velocityX = (- mouseEmulateXPrev + mouseEmulateX)*0.1;
  velocityY = (- mouseEmulateYPrev + mouseEmulateY)*0.1;
  
  mouseEmulateXPrev = mouseEmulateX;
  mouseEmulateYPrev = mouseEmulateY;
}