import 'dart:async';
import 'dart:typed_data';
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
  List<BluetoothCharacteristic> _writeCharacteristic = [];
  double _heartRate = 0;
  List<double> _rates = [];
  double _avgRate = 1;
  double _sittingTime = 2;
  bool _turnButtonStatus = true;
  Guid _serviceUuid = new Guid("00187ddc-9172-4c88-b472-1a3a12fece04");
  Guid _charUuid = new Guid("010955a4-fc04-4fad-8bc9-26cf0de391cb");
  int _stateEmitter = 0;

  double get getHeartRate => _heartRate;
  double get getAvgRate => _avgRate;
  double get getSittingTime => _sittingTime;
  bool get getTurnButtonStatus => _turnButtonStatus;

  List<List<BluetoothCharacteristic>> _characteristicsList = [];
  List<List<BluetoothCharacteristic>> get getCharacteristicsList =>
      _characteristicsList;
  List<ScanResult> get getDevicesList => _devicesList;
  List<BluetoothDevice> get getConnDevicesList => _connDevicesList;

  BlueBloc() : super(BlueInitial()) {
    on<StartScanningEvent>(blueScanning);
    on<TryConnectingEvent>(blueConnecting);
    on<TurnOnEvent>(blueWriteOn);
    on<TurnOffEvent>(blueWriteOff);
    on<ChangeStateEvent>(blueSwitch);
  }

  FutureOr<void> blueWriteOn(TurnOnEvent event, Emitter emit) async {
    if (_writeCharacteristic.length > 0) {
      await _writeCharacteristic[0].write([0x31]);
      pressedButton();
    }

    emit(
      BlueRecieveDeviceOnOff(
        on: getTurnButtonStatus,
      ),
    );
  }

  FutureOr<void> blueWriteOff(TurnOffEvent event, Emitter emit) async {
    if (_writeCharacteristic.length > 0) {
      await _writeCharacteristic[0].write([0x30]);
      pressedButton();
    }

    emit(
      BlueRecieveDeviceOnOff(
        on: getTurnButtonStatus,
      ),
    );
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
    await _getConnectedDevices(emit);
    // emmiting scanning has completed
    switch (_stateEmitter) {
      case 1:
        emit(BlueRecieveBadPostureState());
        break;
      case 2:
        emit(BlueRecieveStretchingState());
        break;
      case 3:
        emit(
          BlueRecieveTimeState(
            time: getSittingTime,
          ),
        );
        break;
      case 4:
        emit(
          BlueRecieveHeartRateState(
            heartRate: getHeartRate,
            avgRate: getAvgRate,
          ),
        );
        break;
      default:
        emit(BlueFoundDevicesState());
    }
  }

  FutureOr<void> blueConnecting(TryConnectingEvent event, Emitter emit) async {
    if (event.device > -1) {
      await _devicesList[event.device].device.connect();
    } else {
      return;
    }
  }

  Future<void> _getConnectedDevices(Emitter emit) async {
    _connDevicesList = await flutterBlue.connectedDevices;

    for (int i = 0; i < _devicesList.length; i++) {
      if (_devicesList[i].device.name == "ESP32") {
        _connDevicesList.add(_devicesList[i].device);
        break;
      }
    }
    if (_connDevicesList.length == 0) emit(BlueFoundDevicesState());

    _connDevicesList.forEach((device) async {
      // send open connection request to confirm connection
      try {
        await device.connect();
        await _discoverServices(device, emit);
      } catch (e) {
        // already connected and paired
        await _discoverServices(device, emit);
      }
    });
  }

  Future<void> _discoverServices(BluetoothDevice device, Emitter emit) async {
    print("======Device services=====");
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        //print("Service:${service}");
        // Reads all characteristics
        _characteristicsList.add(service.characteristics);
      }
      await _showCharacteristics(emit);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _showCharacteristics(Emitter emit) async {
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

        if (chars[i].serviceUuid == _serviceUuid) {
          print("${chars[i].serviceUuid}");
          await chars[i].setNotifyValue(true);
          chars[i].value.listen((value) {
            // do something with new value
            Uint8List temp = Uint8List.fromList(value);
            String valueString = String.fromCharCodes(temp);
            print(valueString);
            receiveValue(valueString, chars[i], emit);
          });
        }
      }
    }
  }

  Future<void> receiveValue(
    String value,
    BluetoothCharacteristic char,
    Emitter emit,
  ) async {
    if (char.serviceUuid == _serviceUuid) {
      if (value == "Bad posture") {
        _stateEmitter = 1;
        add(ChangeStateEvent());
      } else if (value == "Stretching") {
        _stateEmitter = 2;
        add(ChangeStateEvent());
      } else if (value == "The device is on" || value == "The device is off") {
        if (_writeCharacteristic.length == 0 && char.uuid == _charUuid) {
          _writeCharacteristic.add(char);
        }
      } else if (value[0] == "T") {
        //time
        _sittingTime = double.parse(value.substring(1)) / 1000;

        _stateEmitter = 3;
        add(ChangeStateEvent());
      } else if (value[0] == "H") {
        //heartRate
        _heartRate = double.parse(value.substring(1));
        _rates.add(_heartRate);

        _avgRate = _avg(_rates);

        _stateEmitter = 4;
        add(ChangeStateEvent());
      } else
        _stateEmitter = 0;
    } else
      _stateEmitter = 0;
  }

  void pressedButton() {
    _turnButtonStatus = !_turnButtonStatus;
  }

  double _avg(List<double> array) {
    double temp = 0;

    for (int i = 0; i < array.length; i++) {
      temp += array[i];
    }

    return temp / array.length;
  }

  FutureOr<void> blueSwitch(ChangeStateEvent event, Emitter emit) async {
    switch (_stateEmitter) {
      case 1:
        emit(BlueRecieveBadPostureState());
        break;
      case 2:
        emit(BlueRecieveStretchingState());
        break;
      case 3:
        emit(
          BlueRecieveTimeState(
            time: getSittingTime,
          ),
        );
        break;
      case 4:
        emit(
          BlueRecieveHeartRateState(
            heartRate: getHeartRate,
            avgRate: getAvgRate,
          ),
        );
        break;
      default:
        emit(BlueFoundDevicesState());
    }
  }
}
