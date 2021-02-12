part of 'start_sim_bloc.dart';

@immutable
class StartSimState {
  const StartSimState({this.runs, this.error}) : canSubmit = error == null;

  final int runs;
  final String error;
  final bool canSubmit;
}

