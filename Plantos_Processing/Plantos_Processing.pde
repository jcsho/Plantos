import ddf.minim.*;
import processing.serial.*;
Serial port;

Minim minim;
AudioPlayer full;
AudioPlayer empty;

byte[] inBuffer = new byte[255];

int light_val;
int force_val;
int slider_val;

Background background;
ClickBox box;
Cursor pointer;
Plantos pot;

PImage titleBarIcon;

boolean levelsFull = false;
boolean levelsEmpty = false;

void settings() {
  size(1800, 900);
}

void setup() {
  frameRate(60);
  titleBarIcon = loadImage("plant.png");

  surface.setTitle("Plantos");
  surface.setIcon(titleBarIcon);

  background = new Background(width/2, height);
  pointer = new Cursor();
  pot = new Plantos(width/2, height/2).setName("Plant Thing");
  box = new ClickBox(width/2, height - 60);

  //println(Serial.list());

  port = new Serial(this, Serial.list()[32], 9600);
  
  minim = new Minim(this);
  full = minim.loadFile("Good.wav");
  empty = minim.loadFile("Attention.wav");
}

void draw() {

  background(143, 237, 240);

  background.update(pot);

  pointer.mouse(box);

  box.clickBoxes();

  pot.update();
  pot.onClick(box);

  pot.displayLevels();
  
  println(pot.overallValue());
  
  if (pot.overallValue() > 80) {
    port.write('5');
  } else if (pot.overallValue() > 60 && pot.overallValue() < 79) {
    port.write('4');
  } else if (pot.overallValue() > 40 && pot.overallValue() < 59) {
    port.write('3');
  } else if (pot.overallValue() > 20 && pot.overallValue() < 39) {
    port.write('2');
  } else if (pot.overallValue() > 0 && pot.overallValue() < 19) {
    port.write('1');
  } else if (pot.overallValue() == 0) {
    port.write('0');
  }

  if (port.available()>0) { // If data is available to read,
    port.readBytesUntil('&', inBuffer);  //read in all data until '&' is encountered

    if (inBuffer != null) {
      String myString = new String(inBuffer);

      //p is all sensor data (with a's and b's) ('&' is eliminated) ///////////////
      String[] p = splitTokens(myString, "&");  
      if (p.length < 2) return;  //exit this function if packet is broken

      //get light sensor reading //////////////////////////////////////////////////
      String[] light_sensor = splitTokens(p[0], "a");  //get light sensor reading 
      if (light_sensor.length != 3) return;  //exit this function if packet is broken
      light_val = int(light_sensor[1]);
    
      //print("Light sensor:");
      //print(light_val);
      //println(" ");  
    

      //get slider sensor reading //////////////////////////////////////////////////
      String[] slider_sensor = splitTokens(p[0], "b");  //get slider sensor reading 
      if (slider_sensor.length != 3) return;  //exit this function if packet is broken
      slider_val = int(slider_sensor[1]);
    
      //print("Slider sensor:");
      //print(slider_val);
      //println(" "); 
    
      //get slider sensor reading //////////////////////////////////////////////////
      String[] force_sensor = splitTokens(p[0], "c");  //get force sensor reading 
      if (force_sensor.length != 3) return;  //exit this function if packet is broken
      force_val = int(force_sensor[1]);
      
      //print("Force sensor:");
      //print(force_val);
      //println(" "); 
      
      //println("");
    }
  }
  
  if (frameCount % 300 == 0) {

    if (slider_val > 100) {
      println("increase water");
      pot.increaseWater(30, 40);
    }
    
    if (light_val > 100) {
      println("increased sunlight");
      pot.increaseSun(30, 40);
    }
    
    if (force_val > 50 && force_val < 150) {
      println("increased affection");
      pot.increaseHeart(30, 40);
    }
    
    
  }
  
  if (pot.hydration.level >= 80 && pot.sunLight.level >= 80 && pot.affection.level >=80) {  
    levelsFull = true;
  }

  if (levelsFull) {
    full.play();
    println("play full");
    pot.hydration.level = 79;
    pot.sunLight.level = 79;
    pot.affection.level = 79;
    levelsFull = false;
    full.rewind();
  }

  if (pot.hydration.level == 0 && pot.sunLight.level == 0 && pot.affection.level ==0)
    levelsEmpty = true;

  if (levelsEmpty) {
    empty.play();
    println("play empty");
    pot.hydration.level = 1;
    pot.sunLight.level = 1;
    pot.affection.level = 1;
    levelsEmpty = false;
    empty.rewind();
  }
}