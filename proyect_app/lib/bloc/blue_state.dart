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
