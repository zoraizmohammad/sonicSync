#include "pitches.h"
int sensorPin = 12;
int sensorPin1 = 13;
int sensorValue;  // select the input pin for the potentiometer
int confirmValue;
int count = 0;
char bluVal;
int tone 
void setup() {
  // declare the ledPin as an OUTPUT:
  Serial.begin(9600);
  delay(1000);
}


void loop() {
// within specific time created by piecewise func 
  // write signal to audio jack back into speaker 
  if (SerialBT.available()) {
    int toneHz  = SerialBT.read();
  }
  tone(SpeakerJack, toneHz, length(toneHzs))
// write val to audio jack then to speaker 
// -------------------------------------------------------------------
// reading voltage vals and then sending back 
  sensorValue = analogRead(sensorPin);
  confirm = analogRead(sensorPin1)

  while(confirm != 0){
    if(sensorValue == 0){
          count++;
    }
  }
  delay(500);
}