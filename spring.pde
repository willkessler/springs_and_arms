class Spring {
  PVector anchor, armEnd;
  float armLength;
  
  Spring(PVector anc, float al, PVector initialArmEnd) {
    anchor = new PVector(anc.x, anc.y);
    armEnd = new PVector(anchor.x + initialArmEnd.x, anchor.y + initialArmEnd.y);
  }
}
