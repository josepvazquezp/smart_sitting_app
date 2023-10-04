import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
                      "12.5",
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
                      "12.5",
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
                      "12.5",
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
                      "12.5",
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
              backgroundColor: Colors.green,
              radius: 45,
              child: IconButton(
                onPressed: () {
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
