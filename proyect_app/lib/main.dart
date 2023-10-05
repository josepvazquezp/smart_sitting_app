import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyect_app/provider_stats_page.dart';
import 'package:proyect_app/stats_page.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => StatsProvider(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 48, 48)),
      ),
      home: StatsPage(),
    );
  }
}
