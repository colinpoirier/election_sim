part of 'sim_bloc.dart';

@immutable
abstract class SimState {}

class ReadyForSim extends SimState {}

class SimLoading extends SimState {}

class SimResults extends SimState {
  SimResults({this.results});

  final List<String> results;
}

class SimError extends SimState {}
