import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';
import 'package:proyect_app/provider_stats_page.dart';
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
        actions: [
          IconButton(
            tooltip: "Refresh devices list",
            onPressed: () {
              BlocProvider.of<BlueBloc>(context).add(StartScanningEvent());
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: (context, state) {
          if (state is BlueLookingForDevicesState)
            return Center(child: CircularProgressIndicator());
          else if (state is BlueFoundDevicesState)
            return Column(
              children: [
                Text("Dispositivos conectados:"),
                Expanded(child: _connectedDevices(context)),
                Text("Caracteristicas:"),
                Expanded(child: _caracteristics(context)),
              ],
            );
          else
            return Text("Procesando ...");
        },
      ),
      //     Center(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 100,
      //       ),
      //       Text(
      //         'Skill Issue',
      //         style: TextStyle(
      //           fontSize: 46,
      //         ),
      //       ),
      //       Text(
      //         'Sillas inteligentes',
      //         style: TextStyle(
      //           fontSize: 18,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 130,
      //       ),
      //       Material(
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(22)),
      //         color: Colors.cyan,
      //         child: MaterialButton(
      //           onPressed: () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => ChangeNotifierProvider(
      //                   create: (context) => StatsProvider(),
      //                   child: StatsPage(),
      //                 ),
      //               ),
      //             );
      //           },
      //           child: Text(
      //             'Conecta tu dispositivo para empezar',
      //             style: TextStyle(
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  ListView _connectedDevices(BuildContext context) {
    return ListView.builder(
      itemCount: BlocProvider.of<BlueBloc>(context).getConnDevicesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(
            "Bluetooth connected ${BlocProvider.of<BlueBloc>(context).getConnDevicesList[index].name}");
      },
    );
  }

  ListView _caracteristics(BuildContext context) {
    return ListView.builder(
      itemCount:
          BlocProvider.of<BlueBloc>(context).getCharacteristicsList.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(
            "Caracteristic [$index]: ${BlocProvider.of<BlueBloc>(context).getCharacteristicsList[index]}");
      },
    );
  }
}
