const String CENTRAL_ADDRESS_RESOLUTION =
    "00002a4e-0000-1000-8000-00805f9b34fb";
const String BATTERY_LEVEL = "00002a19-0000-1000-8000-00805f9b34fb";
const String VoBLE = "0000fec1-0000-3512-2118-0009af100700";
const String OBJECT_ACTION_CONTROL_POINT =
    "0000fed3-0000-1000-8000-00805f9b34fb";
const String OBJECT_CHANGED = "0000fed2-0000-1000-8000-00805f9b34fb";
const String OBJECT_LIST = "0000fed1-0000-1000-8000-00805f9b34fb";
const String OBJECT_ACTION = "0000fed0-0000-1000-8000-00805f9b34fb";
const String OBJECT_SIZE = "0000fedf-0000-1000-8000-00805f9b34fb";
const String OBJECT_NAME = "0000fede-0000-1000-8000-00805f9b34fb";
// nRF UUID that starts with "0000", indicating that it is a proprietary characteristic defined by Nordic Semiconductor for use with their nRF Toolbox app
const String nRF0 = "00000009-0000-3512-2118-0009af100700";
const String nRF1 = "00000013-0000-3512-2118-0009af100700";
const String nRF3 = "00000012-0000-3512-2118-0009af100700";
// this characteristic is used for "sending test commands" to a device
const String nRF4 = "00000011-0000-3512-2118-0009af100700";
// this characteristic is used for "transmitting data between two devices" using the Transparent UART service.
const String nRF5 = "00000020-0000-3512-2118-0009af100700";
// this characteristic is used for "controlling the state of the LEDs" on a Nordic Semiconductor development board.
const String nRF6 = "00000007-0000-3512-2118-0009af100700";
const String PERIFERIAL_PREFERRED_CONNECTION_PARAMETERS =
    "00002a04-0000-1000-8000-00805f9b34fb";
const String CURRENT_TIME =
    "00002a2b-0000-1000-8000-00805f9b34fb"; // EX. Value : [231, 7, 2, 27, 0, 16, 31, 1, 0, 0, 232]
const String HEART_RATE_CONTROL = "00002a39-0000-1000-8000-00805f9b34fb";
const String LN_CONTROL_POINT = "00002a44-0000-1000-8000-00805f9b34fb";
const String CENTRAL_ADDRESS_RESOLUTION_SIG =
    "00002a46-0000-1000-8000-00805f9b34fb"; //  0x00, the central device does not use address resolution. If the value is 0x01, the central device uses address resolution.
// PNP ID:
// The value of this characteristic is a 7-byte structure that consists of the following fields:
// Vendor ID Source (1 byte) - Indicates the organization that assigned the Vendor ID field.
// Vendor ID (2 bytes) - A unique identifier assigned by the Vendor ID Source organization to the vendor of the device.
// Product ID (2 bytes) - A unique identifier assigned by the vendor to the device.
// Product Version (2 bytes) - A version number assigned by the vendor to the device.
const String PnP_ID = "00002a50-0000-1000-8000-00805f9b34fb";
// SYSTEM ID:
// The value is a 64-bit integer represented as 8 bytes, with the first 6 bytes being the manufacturer and OUI, and the last 2 bytes being the device identifier.
const String SYSTEM_ID = "00002a23-0000-1000-8000-00805f9b34fb";
const String IEEE_REGULATORY = "00002a28-0000-1000-8000-00805f9b34fb";
const String CURRENT_TIME_SIG = "00002a27-0000-1000-8000-00805f9b34fb";
const String SERIAL_NUMBER = "00002a25-0000-1000-8000-00805f9b34fb";
const String PERIFERIAL_PREFERRED_CONNECTION_PARAMETERS_SIG =
    "00002a04-0000-1000-8000-00805f9b34fb";
const String APPEARANCE =
    "00002a01-0000-1000-8000-00805f9b34fb"; // The value of the characteristic is a 16-bit integer, which represents a category assigned to the device
const String DEVICE_NAME =
    "00002a00-0000-1000-8000-00805f9b34fb"; // It has a single value, which is a UTF-8 string LIST OF ASCII CHARACTERS