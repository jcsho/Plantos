public class Plantos {

  private class PlantLevel {

    private PImage img;

    private PVector pos;

    private int level;
    private int time;
    private int refreshTime = 300;

    private final float levelWidth = 0.06*width;
    private final float levelHeight = 0.04*height;
    private final float topHeight = 3*height/8;
    private final float botHeight = 11*height/8;

    private boolean onScreen;

    private String name;

    private PFont font;

    private final color green = color(0, 255, 0);
    private final color gray = color(230);
    private final color yellow = color(237, 222, 45);
    private final color red = color(227, 18, 18);

    private PlantLevel(PImage img, int x, int y, int level) {  // plant level contructor
      this.img = img;
      this.pos = new PVector(x, y);
      this.level = level;

      onScreen = false;
      time = 300;
    }

    private PlantLevel setName(String name) {
      font = loadFont("Norasi-32.vlw");
      textFont(font);
      this.name = name;
      return this;
    }

    private void update() {  // renders plant level and automatic countdowns
      icon();
      drawLevels();
      countDown(5, 10);  //decreases plant level at random betwee 5 and 10
    }

    private void onClick(boolean upGUI, boolean downGUI) {
      if (upGUI && pos.y > topHeight && !onScreen) {
        pos.y -= 5;
      } else if (pos.y == topHeight) {
        onScreen = true;
      }

      if (downGUI && pos.y < botHeight && onScreen) {
        pos.y += 5;
      } else if (pos.y == botHeight) {
        onScreen = false;
      }
    }

    private int increase(int min, int max) {
      int add = (int)random(min, max);
      if ((level + add) < 100) {
        return level + add;
      } else {
        add = 100 - level;
        return level + add;
      }
    }

    private void countDown(int min, int max) {
      time--;
      if (time == 0) {
        //displayLvl();
        level = decrease(min, max);
        time = refreshTime;
      }
    }

    /*private void displayLvl() {
      float x = random(0, width);
      float y = random(0, height);
      int c = 0;
      while (c < 255) {
        fill(c);
        textFont(font);
        text("-" + name, x, y);
        y -= 0.01;
        c += 1;
      }
    }*/

    private int decrease(int min, int max) {
      int minus = (int)random(min, max);
      if ( minus < level ) {
        return level - minus;
      } else {
        return level - level;
      }
    }

    private final void icon() {
      pushStyle();
      imageMode(CENTER);
      image(img, pos.x, pos.y);
      popStyle();
    }

    private final void level(int xPos, int yPos, color c) {
      pushMatrix();
      pushStyle();
      rectMode(CENTER);
      translate(xPos, yPos);
      noStroke();
      fill(c);
      rect(0, 0, levelWidth, levelHeight, 7);
      popStyle();
      popMatrix();
    }

    private final void levels(color c1, color c2, color c3, color c4, color c5) {
      float yPos = 7*pos.y/5;
      level((int)pos.x, (int)yPos, c1); 
      level((int)pos.x, (int)(yPos + levelHeight*2), c2); 
      level((int)pos.x, (int)(yPos + levelHeight*4), c3); 
      level((int)pos.x, (int)(yPos + levelHeight*6), c4); 
      level((int)pos.x, (int)(yPos + levelHeight*8), c5);
    }

    private final void drawLevels() {
      if (level >= 80) {
        levels(green, green, green, green, green);
      } else if (level >= 60 && level <= 79) {
        levels(gray, green, green, green, green);
      } else if (level >= 40 && level <= 59) {
        levels(gray, gray, green, green, green);
      } else if (level >= 20 && level <= 39) {
        levels(gray, gray, gray, yellow, yellow);
      } else if (level >= 1 && level <= 19) {
        levels(gray, gray, gray, gray, red);
      } else if (level <= 0) {
        levels(gray, gray, gray, gray, gray);
      }
    }
  }

  private PlantLevel sunLight, hydration, affection;

  private PImage plant, water, heart, sun;

  private PVector pos;

  private String name;

  private PFont font;

  private final int startValue = 50;
  private final int imgSize = height/5;

  private final float lvlStartHeight = 11*height/8;

  private boolean onScreen, upGUI, downGUI;

  public Plantos(int x, int y) {
    this.pos = new PVector(x, y);

    plant = loadImage("plant.png");
    plant.resize(imgSize, imgSize);
    heart = loadImage("heart2.png");
    heart.resize(imgSize, height/6);
    sun = loadImage("sun.png");
    sun.resize(imgSize, imgSize);
    water = loadImage("water.png");
    water.resize(height/7, imgSize);

    sunLight = new PlantLevel(sun, width/5, (int)lvlStartHeight, startValue).setName("light");
    hydration = new PlantLevel(water, width/2, (int)lvlStartHeight, startValue).setName("water");
    affection = new PlantLevel(heart, 4 * width/5, (int)lvlStartHeight, startValue).setName("affection");

    onScreen = true;
    upGUI = false;
    downGUI = false;
  }

  public Plantos setName(String name) {
    font = loadFont("Norasi-32.vlw");
    textFont(font);
    this.name = name;
    return this;
  }

  public void update() {
    drawPlantos();
    sunLight.update();
    hydration.update();
    affection.update();
  }

  public void onClick(ClickBox c) {
    if (mousePressed && click(c) && onScreen) {
      upGUI = true;
      downGUI = false;
    } else if (mousePressed && click(c) && !onScreen) {
      upGUI = false;
      downGUI = true;
    }

    if (upGUI && pos.y > (-height/2) && onScreen) {
      pos.y -= 5;
    } else if (pos.y == (-height/2)) {
      onScreen = false;
    }

    if (downGUI && pos.y < (height/2) && !onScreen) {
      pos.y += 5;
    } else if (pos.y == (height/2)) {
      onScreen = true;
    }

    sunLight.onClick(upGUI, downGUI);
    hydration.onClick(upGUI, downGUI);
    affection.onClick(upGUI, downGUI);
  }

  public void displayLevels() {
    println("sunlight levels: " + sunLight.level);
    println("water levels: " + hydration.level);
    println("happiness levels: " + affection.level);
  }
  
  public int getSunValue() {
    return sunLight.level;
  }
  
  public int getWaterValue() {
    return hydration.level;
  }
  
  public int getHeartValue() {
    return affection.level;
  }
  
  public int overallValue() {
    int value = (sunLight.level + hydration.level + affection.level) / 3;
    return value;
  }

  public void increaseSun(int min, int max) {
    increaseStat(sunLight, min, max);
  }

  public void increaseWater(int min, int max) {
    increaseStat(hydration, min, max);
  }

  public void increaseHeart(int min, int max) {
    increaseStat(affection, min, max);
  }

  private void increaseStat(PlantLevel lvl, int min, int max) {
    lvl.level = lvl.increase(min, max);
  }

  private final void drawPlantos() {
    imageMode(CENTER);
    image(plant, pos.x, pos.y);

    if (name != null) {
      pushStyle();
      fill(255);
      textFont(font);
      textAlign(CENTER);
      text(name, pos.x, pos.y + 4*plant.height/3);
      popStyle();
    }
  }

  private boolean click(ClickBox c) {
    return mouseX > c.pos.x - c.boxWidth/2 && mouseX < c.pos.x - c.boxWidth/2 + c.boxWidth && mouseY > c.pos.y && mouseY < c.pos.y + c.boxHeight;
  }
}