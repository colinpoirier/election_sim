import 'package:bloc/bloc.dart';
import 'package:election_sim/models/candidate.dart';
import 'package:election_sim/models/states.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meta/meta.dart';

part 'load_json_state.dart';

class LoadJsonCubit extends Cubit<LoadJsonState> {
  LoadJsonCubit() : super(LoadJsonLoading()){
    loadJson();
  }

  void loadJson() async {
    try {
      final rawStates = await rootBundle.loadString('json_data/states-1.json');
      // final rawCandidates = await rootBundle.loadString('json_data/candidates-1.json');
      final rawCandidates = await rootBundle.loadString('json_data/candidates-valid.json');
      final states = States.fromJson(rawStates);
      final candidates = Candidates.fromJson(rawCandidates);
      if (candidates.isValid && states.isValid) {
        emit(JsonLoaded(
          states: states,
          candidates: candidates,
        ));
      } else {
        emit(LoadJsonError(error: 'Election data not valid.'));
      }
    } catch (_) {
      emit(LoadJsonError(error: 'Something went wrong :('));
    }
  }

  void retry() {
    emit(LoadJsonLoading());
    loadJson();
  }
}
