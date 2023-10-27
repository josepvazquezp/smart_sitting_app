import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';
import 'package:proyect_app/widgets_graph/barchart_reports.dart';
import 'package:proyect_app/widgets_graph/month_picker_dialog.dart';
import 'package:proyect_app/widgets_graph/report_table.dart';
import 'package:proyect_app/widgets_graph/sitting_period.dart';
import 'package:proyect_app/widgets_graph/week_picker_dialog.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/provider_reports.dart';


class Reports extends StatefulWidget {
  const Reports({super.key});
  

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    Map<String, List<SittingPeriod>> cleanMap = {};
    List<Map<String, dynamic>> data = [];


  //Inicializamos a que la pantalla tenga la gráfica y datos de la semana actual
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Provider.of<ReportsProvider>(context).calculateAvg(MapEvents().events);
  // }

  void showWeekPicker(BuildContext context, Map<String, List<SittingPeriod>> cleanMap ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WeekPicker(cleanMap: cleanMap);
    }
  );
  }

  void showMonthPicker(BuildContext context,  Map<String, List<SittingPeriod>> cleanMap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MonthPicker(cleanMap: cleanMap);
    }
  );
  }

  Map<String, List<SittingPeriod>> createCleanMap(List<Map<String, dynamic>> data){
    Map<String, List<SittingPeriod>> cleanMap = {};
    for(int i = 0; i<data.length; i++){
      String dateSliced = data[i]['saveAt'].split(' ')[0];
      if (!cleanMap.containsKey(dateSliced)) {
        cleanMap[data[i]['saveAt'].split(' ')[0]] = [
          SittingPeriod(
            date:data[i]['saveAt'].split(' ')[0],
            warnings: data[i]['badCounter'].toString(),
            sittingTime: data[i]['sitting'].toString()
          )
        ];
      }else{
        SittingPeriod temp = SittingPeriod(
          date:data[i]['saveAt'].split(' ')[0],
          warnings: data[i]['badCounter'].toString(),
          sittingTime: data[i]['sitting'].toString());
          cleanMap[dateSliced]?.add(temp);
      }
    }
    return cleanMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Reports", style:TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(10,20.0,10,15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [              
            Padding(
              padding: const EdgeInsets.only(left:10, right:10,bottom:10),
              child: Row(children: [
                Expanded(child: 
                    Container(
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Text("Weekly:",style:TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 15, color:Colors.white),
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                )
                              ), onPressed: () {
                                data = BlocProvider.of<BlueBloc>(context).getSavedValues;
                                cleanMap = createCleanMap(data);
                                showWeekPicker(context,cleanMap);
                              }, 
                              child: const Text('Choose week',style: TextStyle(fontSize: 15, color:Colors.white)),
                            )
                          ),
                        ),
                    
                      ]),
                    ),
                  ),
                  Expanded(child: 
                    Container(
                      child: Column(
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text("Monthly:",style:TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 15, color:Colors.white),
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                                )
                              ), onPressed: () {
                                data = BlocProvider.of<BlueBloc>(context).getSavedValues;
                                data = BlocProvider.of<BlueBloc>(context).getSavedValues;
                                cleanMap = createCleanMap(data);
                                showMonthPicker(context,cleanMap);
                              }, 
                              child: const Text('Choose month',style: TextStyle(fontSize: 15, color:Colors.white)),
                            )
                          ),
                        ),
                      ]),
                    ),
                  ),
              ],),
            ),
      
            //Widget que crea las gráficas de barras
            BarChartReportes(),

            Container(
              child: Column(
                children: [
                Padding(
                  padding: const EdgeInsets.only(top:4.0),
                  child: Text("Bar chart of total time spent sitting per day",
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                ),

              ]),
            ),

            Container(
              child: Column(
                children: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text("Period: ${dateFormat.format(Provider.of<ReportsProvider>(context).startDate)} - ${dateFormat.format(Provider.of<ReportsProvider>(context).endDate)}",
                  style: TextStyle(fontSize: 15),),
                ),

              ]),
            ),

            //Widget que de la tabla con las mediciones 
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ReportTable(),
            ),
      
            SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20, color:Colors.white),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ), onPressed: () {  }, 
                child: const Text('Return',style: TextStyle(fontSize: 15, color:Colors.white)),
              )
            ),
          ],),
        ),
      ),
    );
  }
}