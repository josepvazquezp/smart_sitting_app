/* 
 * ESP32 MVP for maintaining proper posture while sitting:
 * Team members:
 * Carlos Eduardo Garay Olmos
 * Martín Santiago Herrera Soto
 * Jesús Manuel Miramontes Mireles
 * José Pablo Vázquez Partida
*/

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

//We will use the microcontroller as the server
BLEServer* pServer = NULL;

//This characteristic will determine if the device should take into consideration
//the position of the user or not.
BLECharacteristic* pCharacteristic_on = NULL;
BLECharacteristic* pCharacteristic_posture = NULL;
BLECharacteristic* pCharacteristic_time_sitting = NULL;


bool deviceConnected = false;
bool oldDeviceConnected = false;
bool deviceOn = false;
bool badPosture = false; //flag to check the current posture and notify if it has been incorrect after a period of time
bool notifiedBadPosture = false;
bool stretchFlag = false;
bool notifiedStretch = false; //flag to check if there was a notification of bad posture sent
unsigned long blinkTime = millis(); //variable to make the led blink when it is time to stretch
unsigned long baseTimePosture = millis(); //variable that will be used to determine if a certain amount of time has pased since the user acquired a bad posture
unsigned long baseTimeStretch = millis(); //variable that will be used to determine if enough time has passed since the user stretched
unsigned long baseTimeSitting = millis(); //variable that will be used to determine the ammount of miliseconds passed after each cycle.
unsigned long totalTimeSitting = 0; //variable that will store the ammount of time in milliseconds that an user has remained seated, used to calculate the total time
int ledState = LOW; //variable needed to make the LED blink

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "00187ddc-9172-4c88-b472-1a3a12fece04"
#define CHARACTERISTIC_UUID_ON "010955a4-fc04-4fad-8bc9-26cf0de391cb"
#define CHARACTERISTIC_UUID_POSTURE "02895671-a081-4d1c-81f3-02ea41887a1f"
#define CHARACTERISTIC_UUID_TIME_SITTING "03ab05cf-9b49-4291-8f2c-5ec4b11a2661"

int led_power = 2; //ESP32 integrated LED that will determine if the device is active
int led_force = 18; //LED that will turn on after a period of time where the sensors haven't been activated or blink if it is time to stretch
int buzzer = 19;

int force1 = 14;
int force2 = 27;
int force3 = 33;
int force4 = 32;
int forceVal1;
int forceVal2;
int forceVal3;
int forceVal4;

//Function to set the notification to "Good posture", return the posture to false and reset the millisecond count
void setGoodPosture(){
  badPosture = false;
  pCharacteristic_posture->setValue("Good posture");
  pCharacteristic_posture->notify();
  baseTimePosture = millis();
  notifiedBadPosture = false;
}

//Callback function for setting connection variables
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      std::string messagePower;
      messagePower = "The device is on";
      pCharacteristic_on->setValue(messagePower);
      pCharacteristic_time_sitting->setValue("0");
      deviceConnected = true;
      digitalWrite(led_power,HIGH);
      deviceOn = true;
      setGoodPosture();
      baseTimeStretch = millis();
      stretchFlag = false;
      notifiedStretch = false; 
      totalTimeSitting = 0;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      deviceOn = false;
      digitalWrite(led_power,LOW);
      digitalWrite(led_force,LOW);
      ledState = LOW;
      digitalWrite(buzzer,LOW);
      setGoodPosture();
      baseTimeStretch = millis();
      stretchFlag = false;
      notifiedStretch = false; 
      totalTimeSitting = 0;
    }
};

//Callback function for changing the value of on/off when receiving data from the phone. 
class CharacteristicOnCallBack: public BLECharacteristicCallbacks {
  //The function takes a char pointer, we convert it to int.
  void onWrite(BLECharacteristic *pChar) override {
    std::string pChar1_value_stdstr = pChar -> getValue();
    String pChar1_value_str = String(pChar1_value_stdstr.c_str());
    int pChar1_value_int = pChar1_value_str.toInt();
    Serial.print("OnCallbackValue: ");
    Serial.println(pChar1_value_str); //Serial print for debugging
    delay(200); //delay to give time for the bluetooth module to process the data.
    
    //We can turn the led on or off depending on the value sent 
    std::string messagePower;
    if(pChar1_value_int == 0){
      messagePower = "The device is off";
      digitalWrite(led_power,LOW);
      digitalWrite(led_force,LOW);
      ledState = LOW;
      digitalWrite(buzzer,LOW);
      deviceOn = false;
      notifiedBadPosture = false;
      stretchFlag = false;
      notifiedStretch = false;
      pCharacteristic_on->setValue(messagePower);

      std::string strTime= String(totalTimeSitting).c_str();
      pCharacteristic_time_sitting->setValue(strTime);
      pCharacteristic_time_sitting->notify();
      totalTimeSitting = 0;
    }
    if(pChar1_value_int == 1){
      messagePower = "The device is on";
      digitalWrite(led_power,HIGH);
      deviceOn = true;
      pCharacteristic_on->setValue(messagePower);
      setGoodPosture();
      stretchFlag = false;
      notifiedStretch = false;
      baseTimeStretch = millis();
      
    }
    //We set the new value and notify it to test
    pCharacteristic_on->notify();         
    delay(200);
  }
};

//Function to activate the buzzer, blinking led and notification when the user needs to stretch
void activateStretch(){
  //We only notify that we need to stretch once per interval. We also notify the ammount of seconds sitting
    if(!notifiedStretch){
      notifiedStretch = true;
      pCharacteristic_posture->setValue("Stretch");
      pCharacteristic_posture->notify();
      digitalWrite(led_force, HIGH);
      ledState = HIGH;
      digitalWrite(buzzer,HIGH);
      blinkTime = millis();
      baseTimeStretch = millis();

      std::string strTime= String(totalTimeSitting).c_str();
      pCharacteristic_time_sitting->setValue(strTime);
      pCharacteristic_time_sitting->notify();
      totalTimeSitting = 0;
    }
    //We keep the notification up for 10 seconds, when it ends we return the variables and 
    //send a good posture notification.
    else if (millis() > baseTimeStretch + 10000){
      stretchFlag = false;
      baseTimeStretch = millis();
      setGoodPosture();
      notifiedStretch = false;
      
    }
    else{
      // we change the state of the blinking led or buzzer
      if(millis() > blinkTime + 1000){
        if(ledState ==HIGH){
          digitalWrite(led_force, LOW);
          digitalWrite(buzzer,LOW);
          ledState = LOW;
        }else{
          digitalWrite(led_force, HIGH);
          digitalWrite(buzzer,HIGH);
          ledState = HIGH;
        }
        blinkTime = millis();
      }
    }
}

//Function to activate the buzzer, blinking led and notification when the user needs to stretch
void activateBadPosture(){
  if(millis() >= baseTimePosture + 15000 && !notifiedBadPosture){
    pCharacteristic_posture->setValue("Bad posture");
    pCharacteristic_posture->notify();
    digitalWrite(led_force, HIGH);
    ledState = HIGH;
    digitalWrite(buzzer,HIGH);
    notifiedBadPosture = true;
  }
}

//Function to deactivate the buzzer, led and set the notification to good posture
void activateGoodPosture(){
  //If we were notifying bad posture and the user corrected it, stop the alert
  if(notifiedBadPosture){
    setGoodPosture();
    digitalWrite(led_force, LOW);
    ledState = LOW;
    digitalWrite(buzzer,LOW);
    notifiedBadPosture = false;
  }
  //Reset the timer if he has a correct posture
  baseTimePosture = millis();
}

//Function to read the force sensors and determine the posture conditions
void readForceSensors(){
  baseTimeSitting = millis();
  forceVal1 = analogRead(force1);
  forceVal2 = analogRead(force2);
  forceVal3 = analogRead(force3);
  forceVal4 = analogRead(force4);
  //Serial.println(forceVal1); //Serial print to debug the force sensors

  //If the device is on, we notify using the LED that the user isn't sitting properly
  //for this prototipe using our hands to test the pressure, 500 was a good value to determine enough force
  //If any of the sensors doesn't have enough force, the flag will make it so we start the count to 15 seconds
  //in the next cycle
  if(forceVal1 < 500 || forceVal2 < 500 || forceVal3 < 500 || forceVal4 < 500){
    badPosture = true;
  }
  else{
    badPosture = false;
  } 

  //If any of the sensors are on, we consider the user sitting
  if(forceVal1 > 500 || forceVal2 > 500 || forceVal3 > 500 || forceVal4 > 500){
    //Code to add to the total
    totalTimeSitting += millis()- baseTimeSitting;
  }

}

void checkPosture(){
  //The stretching flag takes precedence over the bad posture flag
  if(stretchFlag){
    // Notify the user he needs to stretch
    activateStretch();
  }
  else{
    //If the user has bad posture, check if they still have this posture after 15 seconds
    if(badPosture){
      activateBadPosture();
    }
    //If the user has good posture, stop alarms or keep them off
    else{
      activateGoodPosture();
    }
    
    // If 40 seconds (for testing) have passed since the user started the device or since the last stretch, 
    // set the flags to alert the need of stretching.
    if(millis() >= baseTimeStretch + 40000){
      stretchFlag = true;  
    }
  }
  readForceSensors();
  
}


void setup() {
  pinMode(led_power, OUTPUT);
  pinMode(led_force, OUTPUT);
  pinMode(buzzer, OUTPUT);
  
  Serial.begin(115200);

  // Create the BLE Device
  BLEDevice::init("ESP32");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create power on Characteristic
  pCharacteristic_on = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_ON,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // Create a BLE Descriptor, BLE2902 is a Client Characteristic Configuration Descriptor to enable notifications
  BLE2902* p2902Descriptor = new BLE2902();
  p2902Descriptor->setNotifications(true);
  pCharacteristic_on->addDescriptor(p2902Descriptor);

  // Create the on characteristic callback
  pCharacteristic_on->setCallbacks(new CharacteristicOnCallBack());

  // Create force sensors Characteristic
  pCharacteristic_posture = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_POSTURE,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );


  // Create the posture descriptor
  BLE2902* pPostureDescriptor = new BLE2902();
  pPostureDescriptor->setNotifications(true);
  pCharacteristic_posture-> addDescriptor(pPostureDescriptor);

  // Create time sitting Characteristic
  pCharacteristic_time_sitting = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_TIME_SITTING,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );


  // Create the time sitting descriptor
  BLE2902* pTimeSittingDescriptor = new BLE2902();
  pTimeSittingDescriptor->setNotifications(true);
  pCharacteristic_time_sitting-> addDescriptor(pTimeSittingDescriptor);


  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {
  // Only check the other sensors if there is a connection and the device is set to on
  if (deviceConnected && deviceOn) {
    //Function with main logic to check if the user has proper posture and communicate the information to the phone
    checkPosture();

  }else{
    digitalWrite(led_force,LOW);
    ledState = LOW;
    digitalWrite(buzzer,LOW);
    badPosture = false;
    notifiedBadPosture = false;
    
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(200); // delay to give the bluetooth stack the chance to get things ready      
    pServer->startAdvertising(); // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;

  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    oldDeviceConnected = deviceConnected;
  }

}
