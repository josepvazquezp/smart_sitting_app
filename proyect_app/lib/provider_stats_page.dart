import 'package:flutter/material.dart';

class StatsProvider extends ChangeNotifier {
  double _heartRate = 0;
  double _avgRate = 1;
  double _sittingTime = 2;
  double _avgTime = 3;
  bool _turnButtonStatus = true;

  double get getHeartRate => _heartRate;
  double get getAvgRate => _avgRate;
  double get getSittingTime => _sittingTime;
  double get getAvgTime => _avgTime;
  bool get getTurnButtonStatus => _turnButtonStatus;

  void pressedButton() {
    _turnButtonStatus = !_turnButtonStatus;
    notifyListeners();
  }
}
