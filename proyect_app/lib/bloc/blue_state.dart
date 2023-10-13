part of 'blue_bloc.dart';

abstract class BlueState extends Equatable {
  const BlueState();

  @override
  List<Object> get props => [];
}

class BlueInitial extends BlueState {}

class BlueLookingForDevicesState extends BlueState {}

class BlueFoundDevicesState extends BlueState {}

class BlueRecievedDataState extends BlueState {}

class BlueRecievingDataState extends BlueState {}

class BlueErrorState extends BlueState {
  final String errorMsg;

  BlueErrorState({this.errorMsg = "no error"});
  @override
  List<Object> get props => [errorMsg];
}

class BlueRecieveBadPostureState extends BlueState {} // show dialog

class BlueRecieveStretchingState extends BlueState {} // show dialog stretch

class BlueRecieveDeviceOnOff extends BlueState {
  final bool on;

  BlueRecieveDeviceOnOff({required this.on});
  @override
  List<Object> get props => [on];
} // color green

class BlueRecieveHeartRateState extends BlueState {
  final double heartRate, avgRate;

  BlueRecieveHeartRateState({required this.heartRate, required this.avgRate});
  @override
  List<Object> get props => [heartRate, avgRate];
}

class BlueRecieveTimeState extends BlueState {
  final double time;

  BlueRecieveTimeState({required this.time});
  @override
  List<Object> get props => [time];
}
