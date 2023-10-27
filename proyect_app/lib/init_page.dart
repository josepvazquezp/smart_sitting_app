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
              'Smart chair',
              style: TextStyle(
                fontSize: 46,
              ),
            ),
            // Text(
            //   'Smart chair',
            //   style: TextStyle(
            //     fontSize: 18,
            //   ),
            // ),
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
                    MaterialPageRoute(
                      builder: (context) => StatsPage(),
                    ),
                  );
                },
                child: Text(
                  'Connect your device to begin',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ListView _caracteristics(BuildContext context) {
  //   return ListView.builder(
  //     itemCount:
  //         BlocProvider.of<BlueBloc>(context).getCharacteristicsList.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Text(
  //           "Caracteristic [$index]: ${BlocProvider.of<BlueBloc>(context).getCharacteristicsList[index]}");
  //     },
  //   );
  // }
}
