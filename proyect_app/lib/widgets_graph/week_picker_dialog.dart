import 'package:flutter/material.dart';
import 'package:proyect_app/widgets_graph/sitting_period.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';
import 'package:proyect_app/provider/provider_reports.dart';


class WeekPicker extends StatefulWidget {
  final Map<String, List<SittingPeriod>> cleanMap;

  const WeekPicker({super.key,required Map<String, List<SittingPeriod>> this.cleanMap});

  @override
  _WeekPickerState createState() => _WeekPickerState();
}

class _WeekPickerState extends State<WeekPicker> {
  DateRangePickerController _controller = DateRangePickerController();

 void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    int firstDayOfWeek = DateTime.sunday % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek <=  0? 7 + endDayOfWeek : endDayOfWeek;
    
    PickerDateRange ranges = args.value;
    DateTime date1 = ranges.startDate!;
    DateTime date2 = ranges.endDate?? ranges.startDate!;

    if(date1.isAfter(date2))
    {
      var date=date1;
      date1=date2;
      date2=date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    DateTime dat1 = date1.add(Duration(days: (firstDayOfWeek - day1)));
    DateTime dat2 = date2.add(Duration(days: (endDayOfWeek - day2)));
    if( !isSameDate(dat1, ranges.startDate!)|| !isSameDate(dat2,ranges.endDate!))
    {
      _controller.selectedRange = PickerDateRange(dat1, dat2);
      Provider.of<ReportsProvider>(context, listen: false).startDate = dat1;
      Provider.of<ReportsProvider>(context, listen: false).endDate = dat2;
      Provider.of<ReportsProvider>(context, listen: false).calculateAvg(widget.cleanMap);

    }
}

  bool isSameDate(DateTime date1, DateTime date2) {
    if (date2 == date1) {
      return true;
    }
    return date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
  return AlertDialog(
    titlePadding: EdgeInsets.zero,
    actionsPadding: EdgeInsets.fromLTRB(0,0,0,15),
    contentPadding: EdgeInsets.fromLTRB(24,20,24,10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    title: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: Theme.of(context).primaryColor,),
      alignment: Alignment.center,
      height: 60,
      width: double.infinity,
      child: Text('Choose week', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),)),

    content: 
    
    Container(
      width: 300,
      height: 300,
      child: SfDateRangePicker(
      controller: _controller,
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: selectionChanged,
      monthViewSettings: DateRangePickerMonthViewSettings(enableSwipeSelection: false),
      ),
    ),
      
    actions: [Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          )
        ),
        child: Text('Finish',style: TextStyle(fontSize: 15, color: Colors.white),),
        onPressed: () {
          Navigator.of(context).pop(); 
        },
      ),
    )],
  );

  }


}

