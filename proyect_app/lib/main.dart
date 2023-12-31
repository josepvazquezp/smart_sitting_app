import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';
import 'package:proyect_app/init_page.dart';

void main() async {
  runApp(
    BlocProvider(
      create: (context) => BlueBloc()..add(StartScanningEvent()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 48, 48)),
      ),
      home: InitPage(),
    );
  }
}
