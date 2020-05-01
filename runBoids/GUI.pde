class GUI {
   ArrayList<SpecieTable> allSpecieTables;
  
  GUI() {
    allSpecieTables = new ArrayList<SpecieTable>();
    for (Specie specie: allSpecies) {
      addSpecieTable(specie);
    }
  }
  
  public void addSpecieTable(Specie specie) {
    if (!allSpecieTables.contains(specie))
      allSpecieTables.add(new SpecieTable(specie.getColor(), specie.getBoidsInSpecie().size(), specie.getSID()));
  }
  
  public void drawGUI() {
    fill(0, 0, 0, 100);
    rect(8*width/10, 0, width, height);
    int rectW = 8*width/10;
    int rectH = height;
    fill(255);
    textSize(32);
    textAlign(CENTER);
    text("SPECIES:", rectW + (width-rectW)/2, 32+10);
    int i = 0;
    for (SpecieTable specieTable : allSpecieTables) {
      for (Specie specie: allSpecies) {
        if (specie.getSID() == specieTable.getSID()) {
          specieTable.updateSpecieMembers(specie.getBoidsInSpecie().size());
        }
      }
      if (specieTable.getMembers() > 0) {
        i++;
        specieTable.drawSpecieTable(rectW+20, i*(24+5) + 32+20);
      }
    }
  }
  
  private void sortSpecieTable() {
     
  }
}

class SpecieTable {
  private color scolor;
  private int members;
  private String specieID;
  
  SpecieTable(color c, int m, String s) {
    scolor = c;
    members = m;
    specieID = s;
  }
  
  public String getSID() {
    return specieID;
  }
  
  public int getMembers() {
    return members;
  }
  
  public void updateSpecieMembers(int m) {
    members = m;
  }
  
  public void drawSpecieTable(int x, int y) {
    //Circle Color
    fill(scolor);
    ellipse(x, y-12, 24, 24);
    //Specie Name
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text(specieID, x+10+24+10, y-4);
    //Members
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text(members, width-20, y-4);
  }
}
