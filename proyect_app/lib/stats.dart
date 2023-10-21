import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyect_app/bloc/blue_bloc.dart';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        BlocProvider.of<BlueBloc>(context).getSavedValues;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart sitting app',
          style: TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Text(
            'Datos Recolectados',
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 400,
            height: 650,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: 350,
                      height: 280,
                      color: Colors.black,
                    ),
                    Container(
                      width: 290,
                      height: 250,
                      color: Colors.cyan,
                    ),
                    Column(
                      children: [
                        Text(
                          "${data[index]['id']}",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${data[index]['sitting']}",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${data[index]['badCounter']}",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${data[index]['saveAts']}",
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
