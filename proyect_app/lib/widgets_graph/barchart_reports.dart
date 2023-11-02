import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:proyect_app/provider/provider_reports.dart';
import 'package:provider/provider.dart';


class BarChartReportes extends StatelessWidget {
  const BarChartReportes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,50,8,10),
            child: Container(
              height: 250,
              //razon para crecer la gráfica 
              width: 145 + 36.5*Provider.of<ReportsProvider>(context).listTimeSitting.length,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(drawVerticalLine: false),
                  alignment: BarChartAlignment.center,
                  groupsSpace: 25,
                  barGroups:Provider.of<ReportsProvider>(context).type == "Time"
                  ? List.generate(Provider.of<ReportsProvider>(context).listTimeSitting.length, (index){
                    return BarChartGroupData(x: Provider.of<ReportsProvider>(context).startDate.day + index, 
                      barRods: [BarChartRodData(toY: Provider.of<ReportsProvider>(context).listTimeSitting[index], 
                      color:Theme.of(context).primaryColor, width: 12)], showingTooltipIndicators:[1] );
                    })
                  : List.generate(Provider.of<ReportsProvider>(context).listWarning.length, (index){
                    return BarChartGroupData(x: Provider.of<ReportsProvider>(context).startDate.day + index, 
                      barRods: [BarChartRodData(toY: Provider.of<ReportsProvider>(context).listWarning[index], 
                      color:Theme.of(context).primaryColor, width: 12)], showingTooltipIndicators:[1] );
                    })
                    ,
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: BarTouchTooltipData(fitInsideVertically: false, 
                      tooltipBgColor: Theme.of(context).secondaryHeaderColor,
                      getTooltipItem: (group,groupIndex,rod,rodIndex){
                        String tooltipValue = rod.toY.toStringAsFixed(2);
                        return BarTooltipItem(tooltipValue, TextStyle(color: Colors.blue, fontWeight: FontWeight.bold));
                      }  
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}