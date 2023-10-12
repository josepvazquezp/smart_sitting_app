
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

//We will use the microcontroller as the server
BLEServer* pServer = NULL;

//This characteristic will determine if the device should take into consideration
//the position of the user or not.
BLECharacteristic* pCharacteristic_on = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "04187ddc-9172-4c88-b472-1a3a12fece04"
#define CHARACTERISTIC_UUID_ON "270955a4-fc04-4fad-8bc9-26cf0de391cb"
int led_power = 2; //ESP32 integrated LED that will determine if the device is active
bool first_connection = true;

//Callback function for setting connection variables
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      first_connection = true;
      digitalWrite(led_power,HIGH);
    };

    void onDisconnect(BLEServer* pServer) {
      first_connection = false;
      deviceConnected = false;
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
      pCharacteristic_on->setValue(messagePower);
    }
    if(pChar1_value_int == 1){
      messagePower = "The device is on";
      digitalWrite(led_power,HIGH);
      pCharacteristic_on->setValue(messagePower);
    }
    //We set the new value and notify it to test
    pCharacteristic_on->notify();         
    delay(200);
  }
};


void setup() {
  pinMode(led_power, OUTPUT);
  Serial.begin(115200);

  // Create the BLE Device
  BLEDevice::init("ESP32");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic_on = pService->createCharacteristic(
                      CHARACTERISTIC_UUID_ON,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // Create a BLE Descriptor
  BLE2902* p2902Descriptor = new BLE2902();
  p2902Descriptor->setNotifications(true);
  pCharacteristic_on->addDescriptor(p2902Descriptor);

  // Create the on characteristic callback
  pCharacteristic_on->setCallbacks(new CharacteristicOnCallBack());
  
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
    // Notify to test initial connection
    if (deviceConnected && first_connection) {
      std::string messagePower;
      messagePower = "Succesful connection";
      pCharacteristic_on->setValue(messagePower);
      pCharacteristic_on->notify();  
      first_connection = false;       
      delay(200);
      // delay to give the bluetooth stack time to get ready
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
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }


}
