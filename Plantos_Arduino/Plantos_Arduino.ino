// Code to read values from two sensors and write them to the serial port
int val_light;
int val_slider;
int val_force;
int inputPin0 = 0; // Analog pin 0 - for light sensor
int inputPin1 = 1; // Analog pin 1 - for slider sensor
int inputPin2 = 2; // Analog pin 2 - for force sensor

void setup() {
  Serial.begin(9600); // Start serial communication at 9600 bps
}
void loop() {
  val_light = analogRead(inputPin0)/4; // Read analog input pin0 (light sensor), put in range 0 to 255
  val_slider = analogRead(inputPin1)/4; // Read analog input pin1 (slider sensor), put in range 0 to 255
  val_force = analogRead(inputPin2)/4; // Read analog input pin2 (force sensor), put in range 0, 255
  //'a' packet starts
  Serial.print("a"); //character 'a' will delimit the reading from the light sensor
  Serial.print(val_light);
  Serial.print("a");
  Serial.println();
  //'a' packet ends
  //'b' packet starts
  Serial.print("b"); //character 'b' will delimit the reading from the slider sensor
  Serial.print(val_slider);
  Serial.print("b");
  Serial.println();
  //'b' packet ends
  //'c' packet starts
  Serial.print("c");
  Serial.print(val_force);
  Serial.print("c");
  Serial.println();
  //'c' packet ends
  Serial.print("&"); //denotes end of readings from both sensors
  //print carriage return and newline
  Serial.println();
  delay(1000); // Wait 100ms for next reading
}

