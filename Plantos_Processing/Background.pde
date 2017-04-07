class Background {
  PImage bg;
  PVector pos;
  
  Background(int x, int y) {
    bg = loadImage("dirt2.png");
    bg.resize(width, height*2);
    this.pos = new PVector(x, y);
  }
  
  public void update(Plantos pot) {
    drawBackground();
    
    if (pot.upGUI && pos.y > 0) {
      pos.y -= 5;
    }
    
    if (pot.downGUI && pos.y < height) {
      pos.y += 5;
    }
  }
  
  private void drawBackground() {
    pushStyle();
    imageMode(CENTER);
    image(bg, pos.x, pos.y);
    popStyle();
  }
}