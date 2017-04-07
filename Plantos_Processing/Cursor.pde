public class Cursor {

  PImage downArrow, leaf, upArrow;

  Cursor() {
    downArrow = loadImage("downArrow-02.png");
    downArrow.resize(125/3, 125/3);
    leaf = loadImage("leafPointer-03.png");
    //leaf.resize(125/3, 125/3);
    upArrow = loadImage("upArrow-01.png");
    upArrow.resize(125/3, 125/3);
  }

  void mouse(ClickBox c) {
    pushStyle();
    imageMode(CENTER);
    if (click(c) && pot.onScreen) {
      cursor(upArrow);
    } else if (click(c) && !pot.onScreen) {
      cursor(downArrow);
    } else {
      cursor(leaf);
    }
    popStyle();
  }
  
  private boolean click(ClickBox c) {
    return mouseX > c.pos.x - c.boxWidth/2 && mouseX < c.pos.x - c.boxWidth/2 + c.boxWidth && mouseY > c.pos.y && mouseY < c.pos.y + c.boxHeight;
  }
}