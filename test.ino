//#include "pitches.h"
int sensorPin = A0;
int sensorPin1 = A1;
int sensorValue;  // select the input pin for the potentiometer
int confirm;
int count = 0; 
void setup() {
  // declare the ledPin as an OUTPUT:
  Serial.begin(9600);
  delay(1000);
}


void loop() {
  sensorValue = analogRead(sensorPin);
  confirm = analogRead(sensorPin1);


  if(confirm > 10){
    if(sensorValue < 10){
          count++;
          Serial.println(count % 5);
    }
    // play tone to make sure val is confirmed 
  }

  delay(500);
}