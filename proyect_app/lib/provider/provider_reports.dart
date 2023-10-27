import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:proyect_app/widgets_graph/sitting_period.dart';

class ReportsProvider with ChangeNotifier{
  DateTime _startDate =  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day- DateTime.now().weekday % 7);
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day- DateTime.now().weekday % 7).add(Duration(days: 6));
  List<double> _listWarning = [];
  List<double> _listTimeSitting = [];
  double _warningsAvg = 0;
  double _timeSittingAvg = 0;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  List<double> get listWarning => _listWarning;
  List<double> get listTimeSitting => _listTimeSitting;
  double get warningsAvg => _warningsAvg;
  double get timeSittingAvg => _timeSittingAvg;
  
  set startDate(DateTime date){
    _startDate = date;
    notifyListeners();
  }

  set endDate(DateTime date){
    _endDate = date;
    notifyListeners();
  }

  void calculateAvg(Map<String, List<SittingPeriod>> mapData){
    int numDays = _endDate.difference(_startDate).inDays +1;
    _listWarning = List.filled(numDays, 0); 
    _listTimeSitting = List.filled(numDays,0);
    int counterDaysWithData= 0;
    double sumWarnings = 0;
    double sumTimeSitting = 0;
    _warningsAvg = 0;
    _timeSittingAvg = 0;


    for(int i = 0;i<numDays;i++){
      //Si hay bolus registrados en la fecha, queremos sacar el promedio de estos
      if(mapData.containsKey(_startDate.add(Duration(days: i)).toString().split(' ')[0])){
        counterDaysWithData++;
        sumWarnings = 0;
        sumTimeSitting = 0;

        for(int j = 0; j < mapData[_startDate.add(Duration(days: i)).toString().split(' ')[0]]!.length; j++){
          sumWarnings += double.parse(mapData[_startDate.add(Duration(days: i)).toString().split(' ')[0]]![j].warnings);
          sumTimeSitting += double.parse(mapData[_startDate.add(Duration(days: i)).toString().split(' ')[0]]![j].sittingTime);
        }
        //Lo convertimos a horas
        sumTimeSitting /= 3600;
        _listTimeSitting[i] = sumTimeSitting;
        _listWarning[i] = sumWarnings;
        
        _warningsAvg += sumWarnings;
        _timeSittingAvg += sumTimeSitting; 

      }
    }

    if(counterDaysWithData != 0){
      _warningsAvg /= counterDaysWithData;
      _timeSittingAvg  /= counterDaysWithData;
    }
    notifyListeners();
  }

}