import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'start_sim_event.dart';
part 'start_sim_state.dart';

const _maxRuns = 10000; // arbitrary

class StartSimBloc extends Bloc<StartSimEvent, StartSimState> {
  StartSimBloc() : super(const StartSimState(runs: 5));

  @override
  Stream<StartSimState> mapEventToState(
    StartSimEvent event,
  ) async* {
    final runs = int.tryParse(event.runs);
    if (runs != null && runs > 0 && runs <= _maxRuns ) {
      yield StartSimState(runs: runs);
    } else {
      yield StartSimState(error: '1 - $_maxRuns');
    }
  }
}
