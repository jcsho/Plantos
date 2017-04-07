public class ClickBox {

  PVector pos;

  color white = color(255);
  color darkGrey = color(125);

  int boxWidth = 80;
  int boxHeight = 40;

  ClickBox(int x, int y) {
    pos = new PVector(x, y);
  }

  void clickBoxes() {
    pushStyle();
    strokeWeight(5);
    if (click()) {
      stroke(white);
    } else {
      stroke(darkGrey);
    }
    if (pot.onScreen) {
      line(pos.x, pos.y + 13, pos.x - 10, pos.y + 18);
      line(pos.x, pos.y + 13, pos.x + 10, pos.y + 18);
      line(pos.x, pos.y + 23, pos.x - 10, pos.y + 28);
      line(pos.x, pos.y + 23, pos.x + 10, pos.y + 28);
    } else {
      line(pos.x, pos.y + 28, pos.x - 10, pos.y + 23);
      line(pos.x, pos.y + 28, pos.x + 10, pos.y + 23);
      line(pos.x, pos.y + 18, pos.x - 10, pos.y + 13);
      line(pos.x, pos.y + 18, pos.x + 10, pos.y + 13);
    }
    noFill();
    rect(pos.x - boxWidth/2, pos.y, boxWidth, boxHeight);
    popStyle();
  }

  private boolean click() {
    return mouseX > pos.x - boxWidth/2 && mouseX < pos.x - boxWidth/2 + boxWidth && mouseY > pos.y && mouseY < pos.y + boxHeight;
  }
}