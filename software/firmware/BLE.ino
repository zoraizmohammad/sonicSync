#include <ArduinoBLE.h>
int sensorPin = A0;
int sensorPin1 = A1;
int sensorValue;  // select the input pin for the potentiometer
int confirm;
int count = 0;
char bluVal;
int toneHz;
int SpeakerJack = TX;

BLEService speakService("ee4130ab-85ef-4603-acb4-a2e694ceefcd");
BLEIntCharacteristic countState("d06bfecd-8a97-44a1-b761-f3c5228c7bba", BLERead | BLEWrite | BLENotify);
BLEIntCharacteristic confirmState("d06bfecd-8a97-44a1-b761-f3c5228c7aab", BLERead | BLEWrite | BLENotify);


// Bluetooth® Low Energy Battery Level Characteristic

void setup() {
  Serial.begin(9600);
  countState.setValue(0);
  confirmState.setValue(0);
  pinMode(sensorPin, INPUT);
  pinMode(sensorPin1, INPUT);
  pinMode(SpeakerJack, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT); // initialize the built-in LED pin to indicate when a central is connected

  // begin initialization
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");

    while (1);
  }

  /* Set a local name for the Bluetooth® Low Energy device
     This name will appear in advertising packets
     and can be used by remote devices to identify this Bluetooth® Low Energy device
     The name can be changed but maybe be truncated based on space left in advertisement packet
  */
  speakService.addCharacteristic(countState);
  speakService.addCharacteristic(confirmState);
  BLE.setLocalName("Arduino");
  BLE.setAdvertisedService(speakService); // add the service UUID
  BLE.setAdvertisedServiceUuid("fd654490-aba5-40eb-b784-23a166312bd6");
  BLE.addService(speakService); // Add the battery service

  /* Start advertising Bluetooth® Low Energy.  It will start continuously transmitting Bluetooth® Low Energy
     advertising packets and will be visible to remote Bluetooth® Low Energy central devices
     until it receives a new connection */

  // start advertising
  BLE.advertise();

  Serial.println("Bluetooth® device active, waiting for connections...");
}

void loop() {
  // wait for a Bluetooth® Low Energy central
  BLEDevice central = BLE.central();
  
  // if a central is connected to the peripheral:
  if (central) {
    Serial.print("Connected to central: ");
     //print the central's BT address:
    Serial.println(central.address());
    //turn on the LED to indicate the connection:
    digitalWrite(LED_BUILTIN, HIGH);

    // while the central is connected:
    while (central.connected()) {
        tone(SpeakerJack, toneHz, 1000);
        // Serial.println(toneHz);
        sensorValue = analogRead(sensorPin);
        confirm = analogRead(sensorPin1);
        if(confirm != 0){
          if(sensorValue == 0){
            countState.setValue((countState.value()+1)%5);
            Serial.println(countState.value());
          }
        }
        else{
          tone(SpeakerJack, 164, 3000);
          confirmState.setValue(8);
          Serial.println(confirmState.value());
          // make confirm
          } 
        confirmState.setValue(0);
    }
    // when the central disconnects, turn off the LED:
    digitalWrite(LED_BUILTIN, LOW);
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
    //buttonState.writeValue(20);
 } else {
    digitalWrite(LED_BUILTIN, LOW);
  }
}
