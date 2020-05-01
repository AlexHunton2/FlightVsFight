ArrayList<String> allSIDs = new ArrayList<String>();
ArrayList<Specie> allSpecies = new ArrayList<Specie>();


class Specie {
  private float speed;
  private float strength;
  private String specieID;
  private color bcolor;
  
  private ArrayList<Boid> boidsInSpecie;
  
  final float MAX_STRENGTH = 2;
  final float MIN_STRENGTH = .1;
  final float MAX_SPEED = 10;
  final float MIN_SPEED = .5;
  
  int GREEN = 0;
  
  Specie() {
    strength = random(MIN_STRENGTH, MAX_STRENGTH);
    //strength = random(MIN_STRENGTH, .3);
    speed = 1/strength;
    //speed = 1;
    bcolor = color(map(strength, MIN_STRENGTH, MAX_STRENGTH, 0, 255), GREEN, map(speed, MIN_SPEED, MAX_SPEED, 0, 255));
    specieID = generateSID();
    boidsInSpecie = new ArrayList<Boid>();
    allSpecies.add(this);
    //specieID = "S1234";
  }
  
  Specie(float s) {
    strength = s;
    speed = 1/strength;
    //speed = 1;
    bcolor = color(map(strength, MIN_STRENGTH, MAX_STRENGTH, 0, 255), GREEN, map(speed, MIN_SPEED, MAX_SPEED, 0, 255));
    specieID = generateSID();
    specieID = "S1234";
    boidsInSpecie = new ArrayList<Boid>();
    allSpecies.add(this);
  }
  
  public void mutate() {
    //Overtime, species will slowly mutate for better or for worse
    //More members in a specie, more mutations...
        //strength += random(-MIN_STRENGTH, MIN_STRENGTH);
       // speed = 1/strength;
    bcolor = color(map(strength, MIN_STRENGTH, MAX_STRENGTH, 0, 255), GREEN, map(speed, MIN_SPEED, MAX_SPEED, 0, 255));
  }
  
  public String getSID() {
    return specieID;
  }
  
  public float getSpeed() {
    return this.speed;
  }
  
  public float getStrength() {
    return strength;
  }
  
  public color getColor() {
    return bcolor;
  }
  
  public void addBoid(Boid b) {
    boidsInSpecie.add(b);
  }
  
  public void removeBoid(Boid b) {
    boidsInSpecie.remove(b);
  }
  
  public ArrayList<Boid> getBoidsInSpecie() {
    return boidsInSpecie;
  }
  
  
  private String generateSID() {
    boolean run = true;
    while (run) {
      String genID = "S" + int(random(0, 9999));
      if (allSIDs.size() == 0) {
         run = false;
         allSIDs.add(genID);
         return genID;
      }
      for (int i = 0; i < allSIDs.size(); i++) {
        String SID = allSIDs.get(i);
        if (SID == genID) {
          break;
        }
        //If loop manages to get to end without any breaks
        if (i+1 >= allSIDs.size()) {
          run = false;
          allSIDs.add(genID);
          return genID;
        }
      }
    }
    return "nil"; //Just in case
  }
  
}
