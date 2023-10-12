import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:proyect_app/bloc/my_characteristic_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'blue_event.dart';
part 'blue_state.dart';

class BlueBloc extends Bloc<BlueEvent, BlueState> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> _devicesList = [];
  List<BluetoothDevice> _connDevicesList = [];
  List<List<BluetoothCharacteristic>> _characteristicsList = [];
  List<List<BluetoothCharacteristic>> get getCharacteristicsList =>
      _characteristicsList;
  List<ScanResult> get getDevicesList => _devicesList;
  List<BluetoothDevice> get getConnDevicesList => _connDevicesList;

  BlueBloc() : super(BlueInitial()) {
    on<StartScanningEvent>(blueScanning);
    on<TryConnectingEvent>(blueConnecting);
  }

  FutureOr<void> blueScanning(StartScanningEvent event, Emitter emit) async {
    emit(BlueLookingForDevicesState());
    // scanning and refreshing devices list
    print("======Scanning for devices=====");
    await flutterBlue.startScan(timeout: Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!_devicesList.contains(r)) _devicesList.add(r);
        // print('${r.device} found! rssi: ${r.rssi}');
      }
    });
    await flutterBlue.stopScan();
    await _getConnectedDevices();
    // emmiting scanning has completed
    emit(BlueFoundDevicesState());
  }

  FutureOr<void> blueConnecting(TryConnectingEvent event, Emitter emit) async {
    if (event.device > -1) {
      await _devicesList[event.device].device.connect();
    } else {
      return;
    }
  }

  Future<void> _getConnectedDevices() async {
    _connDevicesList = await flutterBlue.connectedDevices;

    for (int i = 0; i < _devicesList.length; i++) {
      if (_devicesList[i].device.name == "ESP32") {
        _connDevicesList.add(_devicesList[i].device);
        break;
      }
    }

    _connDevicesList.forEach((device) async {
      // send open connection request to confirm connection
      try {
        await device.connect();
        await _discoverServices(device);
      } catch (e) {
        // already connected and paired
        await _discoverServices(device);
      }
    });
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    print("======Device services=====");
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        //print("Service:${service}");
        // Reads all characteristics
        _characteristicsList.add(service.characteristics);
      }
      await _showCharacteristics();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _showCharacteristics() async {
    print("======****** Reading ******=====");
    for (var chars in _characteristicsList) {
      for (int i = 0; i < chars.length; i++) {
        print("Service: ${chars[i].serviceUuid}");
        print("======Reading=====");
        var value =
            await MyCharacteristicParser().decodeCharacteristicValue(chars[i]);
        print("===Value===");
        print(value);
        print("===========");
      }
    }
  }
}
