import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';

class StatsPage extends StatelessWidget {
  StatsPage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Bread\'s',
                style: TextStyle(
                  fontSize: 45,
                ),
              ),
            ),
            BlocBuilder<BlueBloc, BlueState>(
              builder: (context, state) {
                if (state is BlueLookingForDevicesState)
                  return Center(child: CircularProgressIndicator());
                else //if (state is BlueFoundDevicesState)
                  return Column(
                    children: [
                      SizedBox(height: 50),
                      Text("Devices connected:"),
                      Container(height: 100, child: _connectedDevices(context)),
                      // Text("Caracteristicas:"),
                      // Expanded(child: _caracteristics(context)),
                    ],
                  );
                // else
                //   return Text("Procesando ...");
              },
            ),
            Divider(
              thickness: 2,
            ),
            BlocBuilder<BlueBloc, BlueState>(
              builder: (context, state) {
                if (state is BlueRecieveDeviceOnOff)
                  return _showHeartRate(
                    context,
                    BlocProvider.of<BlueBloc>(context).getHeartRate,
                    BlocProvider.of<BlueBloc>(context).getAvgRate,
                  );
                else
                  return _showHeartRate(
                    context,
                    BlocProvider.of<BlueBloc>(context).getHeartRate,
                    BlocProvider.of<BlueBloc>(context).getAvgRate,
                  );
              },
            ),
            Divider(
              thickness: 2,
            ),
            BlocBuilder<BlueBloc, BlueState>(
              builder: (context, state) {
                if (state is BlueRecieveDeviceOnOff)
                  return _showTime(
                    context,
                    BlocProvider.of<BlueBloc>(context).getSittingTime,
                  );
                else
                  return _showTime(
                    context,
                    BlocProvider.of<BlueBloc>(context).getSittingTime,
                  );
              },
            ),
            Divider(
              thickness: 2,
            ),
            BlocBuilder<BlueBloc, BlueState>(
              builder: (context, state) {
                if (state is BlueRecieveDeviceOnOff)
                  return _showButton(
                    context,
                    BlocProvider.of<BlueBloc>(context).getTurnButtonStatus,
                  );
                else
                  return _showButton(
                    context,
                    BlocProvider.of<BlueBloc>(context).getTurnButtonStatus,
                  );
              },
            ),
            BlocBuilder<BlueBloc, BlueState>(
              builder: (context, state) {
                if (state is BlueRecieveBadPostureState) {
                  _showPostureDialog(context);
                } else if (state is BlueRecieveStretchingState) {
                  _showStretchDialog(context);
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _showTime(BuildContext context, double time) {
    return Row(
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
              "${time}",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _showHeartRate(BuildContext context, double heart, double avg) {
    return Row(
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
              "${heart}",
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
              "${avg}",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 1, 90, 126),
              ),
            ),
          ],
        ),
      ],
    );
  }

  CircleAvatar _showButton(BuildContext context, bool on) {
    return CircleAvatar(
      backgroundColor: on ? Colors.green : Colors.red,
      radius: 45,
      child: IconButton(
        onPressed: () {
          if (on) {
            BlocProvider.of<BlueBloc>(context).add(TurnOffEvent());
          } else {
            BlocProvider.of<BlueBloc>(context).add(TurnOnEvent());
          }
        },
        icon: Icon(
          Icons.power_settings_new,
          color: Colors.white,
        ),
        iconSize: 58,
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

  void _showStretchDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Advice"),
          content: Text(
            "Is time to Stretch my friend.",
          ),
        );
      },
    );
  }

  Widget _connectedDevices(BuildContext context) {
    if (BlocProvider.of<BlueBloc>(context).getConnDevicesList.length == 0)
      return Text("None");
    else
      return ListView.builder(
        itemCount: BlocProvider.of<BlueBloc>(context).getConnDevicesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
              "${BlocProvider.of<BlueBloc>(context).getConnDevicesList[index].name}");
        },
      );
  }
}
