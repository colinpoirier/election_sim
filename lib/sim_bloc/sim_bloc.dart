import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:election_sim/cubit/load_json_cubit.dart';
import 'package:election_sim/models/candidate.dart';
import 'package:election_sim/models/states.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';

part 'sim_event.dart';
part 'sim_state.dart';

class SimBloc extends Bloc<SimEvent, SimState> {
  SimBloc(LoadJsonCubit cubit) : super(SimLoading()) {
    _loadJsonSub = cubit.listen((state) {
      if (state is JsonLoaded) {
        _candidates = state.candidates;
        _states = state.states;
        add(LoadJsonComplete());
      }
    });
  }

  StreamSubscription _loadJsonSub;

  Candidates _candidates;
  States _states;

  @override
  Future<void> close() {
    _loadJsonSub.cancel();
    return super.close();
  }

  @override
  Stream<SimState> mapEventToState(
    SimEvent event,
  ) async* {
    if (event is LoadJsonComplete) {
      yield ReadyForSim();
    } else if (event is StartSim) {
      yield* _mapStartSimToState(event);
    }
  }

  Stream<SimState> _mapStartSimToState(StartSim event) async* {
    yield SimLoading();
    try {
      final candidates = _candidates.toJson();
      final states = _states.toJson();
      final runs = '${event.runs}';
      // use compute to avoid hogging main thread
      final data = await compute(doThing, <String>[runs, candidates, states]);
      yield SimResults(results: data);
    } catch (_) {
      yield SimError();
    }
  }
}


List<String> doThing(List<String> args) {
  final runs = int.parse(args[0]);
  final candidates = Candidates.fromJson(args[1]);
  final states = States.fromJson(args[2]);
  
  final Random r = Random();

  List<String> results = [];

  Map<Candidate, int> totalVotes;
  for(int i = 0; i < runs; i++) {
    totalVotes = {};
    results.add('Run ${i + 1}:');
    for (final state in states.states) {
      final id = state.id;
      int j = 0;
      Candidate stateWinner;
      final win = r.nextInt(101); // [0, 100]. 101 not included
      for (final candidate in candidates.candidates){
        final chance = candidate.stateChancesOfWinning.firstWhere((e) => e.stateId == id, orElse: () => null)?.chance;
        if (chance == null) {
           // candidates are not running in this state
          break;
        }
        // determine if candidate is winner
        if (chance + j >= win) {
          stateWinner = candidate;
          break;
        } else {
          j += chance;
        }
      }
      if (stateWinner == null) {
        // no winner. go to next state
        continue;
      }
      final winChance = stateWinner.stateChancesOfWinning.firstWhere((e) => e.stateId == id).chance;
      results.add('${stateWinner.name} won ${state.name} getting ${state.votes} votes with a $winChance% win chance${winChance <= 30 ? ' (an upset)' : ''}.');
      totalVotes.update(stateWinner, (value) => value + state.votes, ifAbsent: () => state.votes);
    }
    // get candidates with highest total votes
    final sortedVotes = totalVotes.values.toList()..sort();
    final electionWinners = totalVotes.entries.where((element) => element.value == sortedVotes.last).toList();
    if (electionWinners.length == 1){
      // handle one winner
      final electionWinner = electionWinners.first.key;
      results.add('Overall winner is ${electionWinner.name} with ${sortedVotes.last} votes.');
    } else {
      // handle tie
      final lastWinner = electionWinners.removeLast();
      final listWinners = electionWinners.map((e) => e.key.name).toList().toString().replaceAll(RegExp(r'[\[|\]]'), '');
      results.add('It was a tie between $listWinners${listWinners.length > 1 ? ',' : ''} and ${lastWinner.key.name}.');
    }
    results.add(''); // hacky but functional
  }

  return results;
}