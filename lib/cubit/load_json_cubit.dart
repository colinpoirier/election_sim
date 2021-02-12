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
      String error;
      if (!candidates.haveSameStates) {
        error = 'Candidates don\'t have same states';
      }
      if (!candidates.haveValidChances) {
        final addError = 'don\'t have valid chances';
        error = error == null ? 'Candidates $addError' : '$error and $addError';
      }
      if (error == null) {
        emit(JsonLoaded(
          states: states,
          candidates: candidates,
        ));
      } else {
        emit(LoadJsonError(error: '$error.'));
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
