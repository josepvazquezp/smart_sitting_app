import 'package:flutter/material.dart';
import 'package:proyect_app/provider/provider_reports.dart';
import 'package:provider/provider.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
                border: TableBorder.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                  borderRadius: BorderRadius.circular(15),
                  style: BorderStyle.solid
                ),
                columnWidths: const <int, TableColumnWidth>{
                  0: FractionColumnWidth(0.65),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                          color: Theme.of(context).primaryColor,),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("Feature",style: TextStyle(color:Colors.white, fontSize: 15),)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                          color: Theme.of(context).primaryColor,),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("Average",style: TextStyle(color:Colors.white, fontSize: 15),)),
                        ),
                      ),
                    ],
                  ),

                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("Number of Warnings")),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("${Provider.of<ReportsProvider>(context, listen: false).warningsAvg.toStringAsFixed(2)}")),
                        )
                      ),
                    ],
                  ),

                  TableRow(
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("Time Sitting")),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(child: Text("${Provider.of<ReportsProvider>(context, listen: false).timeSittingAvg.toStringAsFixed(2)} hrs")),
                        )
                      ),
                    ],
                  ),
                ],
              );
  }
}