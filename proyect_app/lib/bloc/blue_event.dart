part of 'blue_bloc.dart';

abstract class BlueEvent extends Equatable {
  const BlueEvent();

  @override
  List<Object> get props => [];
}

class StartScanningEvent extends BlueEvent {
  @override
  List<Object> get props => [];
}

class TryConnectingEvent extends BlueEvent {
  final int device;

  TryConnectingEvent({this.device = -1});
  @override
  List<Object> get props => [device];
}
