/*
MUCH OF THIS CODE IS INSPIRED/TAKEN FROM
-https://www.processing.org/examples/flocking.html
-http://www.vergenet.net/~conrad/boids/pseudocode.html

HOWEVER HEAVY MODIFICATIONS ARE MADE / AN ENTIRE REWRITE WAS NECESSARY FOR SIM MECHANICS
*/
class Boid {
  private PVector positionV;
  private PVector velocityV;
  private PVector accelerationV;
  private Specie specie;
  private boolean fought;
  private float speed;
  private color bcolor;
  
  final float SIZE = 7f;
  final float NEAR_DIST = 30f; 
  final float MAX_SPEED = 10;
  final float MAX_FORCE = .03;
  final float FRIENDSHIP_IS_MAGIC = 1;
  
  
  Boid(int x, int y) {
    allBoids.add(this);
    accelerationV = new PVector(0, 0);
    positionV = new PVector(x, y);
    velocityV = PVector.random2D();
    specie = new Specie();
    specie.addBoid(this);
  }
  
  Boid(int x, int y, float strength) {
    allBoids.add(this);
    accelerationV = new PVector(0, 0);
    positionV = new PVector(x, y);
    velocityV = PVector.random2D();
    specie = new Specie(strength);
    specie.addBoid(this);
    gui.addSpecieTable(specie);
  }
  
  //PUBLIC METHODS:
  public void run() {
    calculate();
    wrap();
    render();
  }
  
  public boolean hasFought() {
    return fought;
  }
  
  public void setFought(boolean f) {
    fought = f;
  }
 
  //PRIVATE METHODS:
  private void wrap() {
    if (positionV.x < -SIZE) positionV.x = width+SIZE;
    if (positionV.y < -SIZE) positionV.y = height+SIZE;
    if (positionV.x > width+SIZE) positionV.x = -SIZE;
    if (positionV.y > height+SIZE) positionV.y = -SIZE;
  }
  
  private void calculate() {
    specie.mutate();
    assimilate();
    accelerationV = accelerationV.add(cohesion());
    accelerationV = accelerationV.add(allignment()); 
    accelerationV = accelerationV.add(seperation());
    
    
    velocityV.add(accelerationV);
    velocityV.mult(specie.getSpeed()/.1);
    velocityV.limit(specie.getSpeed()*3);
    positionV.add(velocityV);
    accelerationV.mult(0);
  }
  
  private void render() {
    fill(specie.getColor());
    pushMatrix();
    translate(positionV.x, positionV.y);
    rotate(velocityV.heading() + radians(90));
    beginShape(TRIANGLES);
    vertex(0, -SIZE*2);
    vertex(-SIZE, SIZE*2);
    vertex(SIZE, SIZE*2);
    endShape();
    popMatrix();
  }
  
  private void updateSpecie(Specie s) {
    specie.removeBoid(this);
    s.addBoid(this);
    specie = s;
  }
  
  private int getFriends(Boid b) {
    int count = 1;
    for (Boid boid : getNearBoids(b)) {
      if (boid.specie.getSID() == b.specie.getSID()) {
        count++;
      }
    }
    return count;
  }
  
  private void assimilate() {
    for (Boid boid: allBoids) {
      boid.setFought(false);
    }
    ArrayList<Boid> nearBoids = getNearBoids();
    for (Boid other : nearBoids) {
      if (other != this) {
        if (!other.hasFought() && !this.hasFought()) {
          other.setFought(true);
          this.setFought(true);
          float thisFriends = getFriends(this) * FRIENDSHIP_IS_MAGIC;
          float otherFriends = getFriends(other) * FRIENDSHIP_IS_MAGIC;
          float thisScore = thisFriends * (this.specie.getStrength()) - (otherFriends * other.specie.getSpeed());
          float otherScore = otherFriends * (other.specie.getStrength() - (thisFriends * this.specie.getSpeed()));
          float totalStrength = thisScore + otherScore;
          float randomNum = random(0, totalStrength);
          float stronger = max(thisScore, otherScore);
          float weaker = min(thisScore, otherScore);
          if (randomNum > stronger) {
            //LESSER STRENGTH WINS
            if (thisScore == weaker) {
              //THIS WINS:
              other.updateSpecie(this.specie);
            } else if (otherScore == weaker) {
              //OTHER WINS:
              this.updateSpecie(other.specie);
            }
          } else {
            //GREATER STRENGTH WINS
            if (thisScore == stronger) {
              //THIS WINS:
              other.updateSpecie(this.specie);
            } else if (otherScore == stronger) {
              //OTHER WINS:
              this.updateSpecie(other.specie);
            }
          }
        }
      }
    }
  }
  
  private PVector seek(PVector target) {
    PVector desired = PVector.sub(target, positionV);
    desired.normalize();
    desired.mult(specie.getSpeed());
    PVector steer = PVector.sub(desired, velocityV);
    steer.limit(MAX_FORCE);
    return steer;
  }
  
  private PVector cohesion() {
    ArrayList<Boid> nearBoids = new ArrayList<Boid>();
    for (Boid boid: getNearBoids()) {
      if (boid.specie.getSID() == this.specie.getSID()) {
        nearBoids.add(boid);
      }
    }
    
    PVector cv = new PVector(0, 0);
    for (Boid boid : nearBoids) {
      cv.add(boid.positionV);
    }
    if (nearBoids.size() > 0) {
      cv.div(nearBoids.size());
      return seek(cv);
    }
    return cv;
  }
  
  private PVector seperation() {
    ArrayList<Boid> nearBoids = getNearBoids();
    PVector sv = new PVector(0, 0);
    for (Boid boid : nearBoids) {
      float dist = 50f;
      PVector diff = PVector.sub(positionV, boid.positionV);
      diff.normalize();
      diff.div(dist);
      sv.add(diff);
    }
    if (nearBoids.size() > 0) {
      sv.div(float(nearBoids.size()));
    }
    
    if (sv.mag() > 0) {
      sv.normalize();
      sv.mult(specie.getSpeed());
      sv.sub(velocityV);
      sv.limit(MAX_FORCE);
    }
    return sv.mult(5*(specie.getSpeed()));
  }
  
  private PVector allignment() {
    ArrayList<Boid> nearBoids = new ArrayList<Boid>();
    for (Boid boid: getNearBoids()) {
      if (boid.specie.getSID() == this.specie.getSID()) {
        nearBoids.add(boid);
      }
    }
    
    PVector av = new PVector(0, 0);
    for (Boid boid: nearBoids) {  
      av.add(boid.velocityV);
    }
    if (nearBoids.size() > 0) {
      av.div(nearBoids.size());
      av.setMag(specie.getSpeed());
      
      av.normalize();
      av.mult(specie.getSpeed());
      PVector steer = PVector.sub(av, velocityV);
      steer.limit(specie.getSpeed());
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }
  
  private ArrayList<Boid> getNearBoids() {
    ArrayList<Boid> nearBoids = new ArrayList<Boid>();
    for (Boid boid: allBoids) {
      if (boid != this) {
        float dist = positionV.dist(boid.positionV);
        if (dist < NEAR_DIST && dist > 0) { 
          nearBoids.add(boid);
        }
      }
    }
    return nearBoids;
  }
  
  private ArrayList<Boid> getNearBoids(Boid b) {
    ArrayList<Boid> nearBoids = new ArrayList<Boid>();
    for (Boid boid: allBoids) {
      if (boid != b) {
        float dist = PVector.dist(this.positionV, boid.positionV);
        dist = abs(dist);
        if (dist < NEAR_DIST && dist > 0) { 
          nearBoids.add(boid);
        }
      }
    }
    return nearBoids;
  }
}
