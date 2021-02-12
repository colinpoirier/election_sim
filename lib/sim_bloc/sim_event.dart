part of 'sim_bloc.dart';

@immutable
abstract class SimEvent {}

class LoadJsonComplete extends SimEvent {}

class StartSim extends SimEvent {
  StartSim({this.runs = 5});

  final int runs;
}