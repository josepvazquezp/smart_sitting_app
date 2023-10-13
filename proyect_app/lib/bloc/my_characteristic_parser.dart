import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:proyect_app/constants.dart';

class MyCharacteristicParser {
  Future<String> decodeCharacteristicValue(
      BluetoothCharacteristic characteristic) async {
    if (!characteristic.properties.read) return "read is not allowed";
    await Future.delayed(Duration(milliseconds: 500));
    var char = await characteristic.read();
    final Uint8List value = Uint8List.fromList(char);
    final String valueString = String.fromCharCodes(char);

    if (value.length == 0) {
      return "Empty value";
    }
    try {
      if (characteristic.uuid.toString() == BATTERY_LEVEL) {
        return "Batery level: ${char[0]}%";
      }
      ByteData dataValue = ByteData.sublistView(Uint8List.fromList(char));
      double floatValue = dataValue.getFloat32(0, Endian.little);
      print("Value String: $valueString");
      print("Data Value : $dataValue");
      print("Float Value : $floatValue");
      print("Value : $value");
      return valueString;
    } catch (e) {
      return valueString;
    }
  }
}
