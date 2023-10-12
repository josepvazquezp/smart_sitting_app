import 'package:flutter/material.dart';

class StatsProvider extends ChangeNotifier {
  double _heartRate = 0;
  List<double> _rates = [];
  double _avgRate = 1;
  double _sittingTime = 2;
  List<double> _times = [];
  double _avgTime = 3;
  bool _turnButtonStatus = true;

  double get getHeartRate => _heartRate;
  double get getAvgRate => _avgRate;
  double get getSittingTime => _sittingTime;
  double get getAvgTime => _avgTime;
  bool get getTurnButtonStatus => _turnButtonStatus;

  void setHeartRate(String heartRate) {
    _heartRate = double.parse(heartRate);
    _rates.add(_heartRate);

    _avgRate = _avg(_rates);

    notifyListeners();
  }

  void setSittingTime(String time) {
    _sittingTime = double.parse(time);
    _times.add(_sittingTime);

    _avgTime = _avg(_times);

    notifyListeners();
  }

  void pressedButton() {
    _turnButtonStatus = !_turnButtonStatus;
    notifyListeners();
  }

  double _avg(List<double> array) {
    double temp = 0;

    for (int i = 0; i < array.length; i++) {
      temp += array[i];
    }

    return temp / array.length;
  }
}
