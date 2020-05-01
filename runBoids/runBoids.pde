ArrayList<Boid> allBoids = new ArrayList<Boid>();

GUI gui;

void setup() {
  size(1280, 800);
  for (int i = 0; i < 300; i++) {
    new Boid(int(random(0, width)), int(random(0, height)));
  }
  gui = new GUI();
}

void draw() {
  background(100);  
  for (Boid boid: allBoids) {
    boid.run();
  }
  gui.drawGUI();
}

void mouseClicked() {
   for (int i = 0; i < 150; i++) {
      new Boid(int(mouseX + random(0, 300)), int(mouseY + random(0, 300)), .1);;
   }
}
