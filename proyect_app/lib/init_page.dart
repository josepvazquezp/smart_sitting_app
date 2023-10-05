import 'package:flutter/material.dart';
import 'package:proyect_app/stats_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Smart sitting app'),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              'Skill Issue',
              style: TextStyle(
                fontSize: 46,
              ),
            ),
            Text(
              'Sillas inteligentes',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              color: Colors.cyan,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => StatsPage()));
                },
                child: Text(
                  'Conecta tu dispositivo para empezar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
