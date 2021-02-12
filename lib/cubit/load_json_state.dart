part of 'load_json_cubit.dart';

@immutable
abstract class LoadJsonState {}

class LoadJsonLoading extends LoadJsonState {}

class JsonLoaded extends LoadJsonState {
  JsonLoaded({this.states, this.candidates});

  final States states;
  final Candidates candidates;
}

class LoadJsonError extends LoadJsonState {
  LoadJsonError({this.error});

  final String error;
}
