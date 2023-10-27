import 'package:flutter/material.dart';

class DropdownMenuYears extends StatefulWidget {

  const DropdownMenuYears({super.key,required this.controllerYear});

  final TextEditingController controllerYear;
  @override
  State<DropdownMenuYears> createState() => _DropdownMenuYearsState(controllerYear: controllerYear);
}

class _DropdownMenuYearsState extends State<DropdownMenuYears> {
  int? selectedYear;
  final TextEditingController controllerYear;

  _DropdownMenuYearsState({required this.controllerYear});

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<int>> yearEntries = <DropdownMenuEntry<int>>[];
    for (final int year in years) {
      yearEntries.add(
        DropdownMenuEntry<int>(
            value: year, label: "$year",),
      );
    }

    return DropdownMenu<int>(
        width: 120,
        menuHeight: 200,
        initialSelection: DateTime.now().year,
        controller: controllerYear,
        dropdownMenuEntries: yearEntries,
        onSelected: (int? year) {
          setState(() {
            selectedYear = year;
          });
        },
      );
  }
            
  List<int> years = List.generate(2030 - 2015 + 1, (index) => 2015 + index);

}