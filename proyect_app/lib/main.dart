import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';
import 'package:proyect_app/provider_stats_page.dart';
import 'package:proyect_app/init_page.dart';

void main() => runApp(
      // ChangeNotifierProvider(
      //     create: (context) => StatsProvider(),
      //     child: MyApp(),
      //   ),
      BlocProvider(
        create: (context) => BlueBloc()..add(StartScanningEvent()),
        child: MyApp(),
      ),
    );

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
