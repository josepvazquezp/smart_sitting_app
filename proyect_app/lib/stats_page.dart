import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyect_app/provider_stats_page.dart';

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart sitting app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Breac\'s',
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Heart Rate",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "${context.watch<StatsProvider>().getHeartRate}",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Average Rate",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 1, 90, 126),
                        ),
                      ),
                    ),
                    Text(
                      "${context.watch<StatsProvider>().getAvgRate}",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 1, 90, 126),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Sitting Time",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "${context.watch<StatsProvider>().getSittingTime}",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Average Time",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 1, 90, 126),
                        ),
                      ),
                    ),
                    Text(
                      "${context.watch<StatsProvider>().getAvgTime}",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 1, 90, 126),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            CircleAvatar(
              backgroundColor:
                  context.watch<StatsProvider>().getTurnButtonStatus
                      ? Colors.green
                      : Colors.red,
              radius: 45,
              child: IconButton(
                onPressed: () {
                  context.read<StatsProvider>().pressedButton();
                  _showPostureDialog(context);
                },
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                iconSize: 58,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostureDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(
            "Bad posture STU-PD2 please sit correctly!",
          ),
        );
      },
    );
  }
}
