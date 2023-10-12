
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

//We will use the microcontroller as the server
BLEServer* pServer = NULL;

//This characteristic will determine if the device should take into consideration
//the position of the user or not.
BLECharacteristic* pCharacteristic_on = NULL;
BLECharacteristic* pCharacteristic_force = NULL;

bool deviceConnected = false;
bool oldDeviceConnected = false;
bool deviceOn = false;
bool notifiedBadPosture = false; //flag to only notify once of the bad posture until it happens again

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "04187ddc-9172-4c88-b472-1a3a12fece04"
#define CHARACTERISTIC_UUID_ON "010955a4-fc04-4fad-8bc9-26cf0de391cb"
#define CHARACTERISTIC_UUID_FORCE "02895671-a081-4d1c-81f3-02ea41887a1f"

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


//Callback function for setting connection variables
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      digitalWrite(led_power,HIGH);
      deviceOn = true;
      notifiedBadPosture = false;
      pCharacteristic_force->setValue("Good posture");
      pCharacteristic_force->notify();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      deviceOn = false;
      digitalWrite(led_power,LOW);
      digitalWrite(led_force,LOW);
      digitalWrite(buzzer,LOW);

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
      digitalWrite(buzzer,LOW);


      deviceOn = false;
      pCharacteristic_on->setValue(messagePower);
    }
    if(pChar1_value_int == 1){
      messagePower = "The device is on";
      digitalWrite(led_power,HIGH);
      deviceOn = true;
      pCharacteristic_on->setValue(messagePower);
    }
    //We set the new value and notify it to test
    pCharacteristic_on->notify();         
    delay(200);
  }
};


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
  pCharacteristic_force = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_FORCE,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );


  // Create the force descriptor
  BLE2902* pForceDescriptor = new BLE2902();
  p2902Descriptor->setNotifications(true);
  pCharacteristic_force-> addDescriptor(pForceDescriptor);

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
      forceVal1 = analogRead(force1); 
      forceVal2 = analogRead(force2);
      forceVal3 = analogRead(force3);
      forceVal4 = analogRead(force4);
      //Serial.println(forceVal1); //Serial print to debug the force sensors

      //If the device is on, we notify using the LED that the user isn't sitting properly
      //for this prototipe using our hands to test the pressure, 500 was a good value to determine enough force
      if(forceVal1 < 500 || forceVal2 < 500 || forceVal3 < 500 || forceVal4 < 500){
        digitalWrite(led_force, HIGH);
        digitalWrite(buzzer,HIGH);
        if(!notifiedBadPosture){
          notifiedBadPosture = true;
          pCharacteristic_force->setValue("Bad posture");
          pCharacteristic_force->notify();         
        }
        
      }

      else{
        if(notifiedBadPosture){        
          notifiedBadPosture = false;
          pCharacteristic_force->setValue("Good posture");
          pCharacteristic_force->notify();
        }
        digitalWrite(led_force, LOW);
        digitalWrite(buzzer,LOW); 
      }
        
    }else{
      digitalWrite(led_force,LOW);
      digitalWrite(buzzer,LOW);

    }
    // disconnecting
    if (!deviceConnected && oldDeviceConnected) {
      delay(200); // delay to give the bluetooth stack the chance to get things ready      
      pServer->startAdvertising(); // restart advertising
      digitalWrite(led_force,LOW);
      Serial.println("start advertising");
      oldDeviceConnected = deviceConnected;

    }
    // connecting
    if (deviceConnected && !oldDeviceConnected) {
      oldDeviceConnected = deviceConnected;
    }


}
