import 'dart:convert';

import 'package:election_sim/models/candidate.dart';
import 'package:election_sim/models/states.dart';

class ElectionResults {
  ElectionResults({
    this.winner,
    this.state,
  }) : winChance = winner.stateChancesOfWinning.firstWhere((e) => e.stateId == state.id).chance;

  final Candidate winner;
  final StateData state;
  final int winChance;

  Map<String, dynamic> toMap() {
    return {
      'winner': winner?.toMap(),
      'state': state?.toMap(),
    };
  }

  factory ElectionResults.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ElectionResults(
      winner: Candidate.fromMap(map['winner']),
      state: StateData.fromMap(map['state']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectionResults.fromJson(String source) => ElectionResults.fromMap(json.decode(source));

  @override
  String toString() => 'ElectionResults(winner: $winner, state: $state)';

  String formatted() => '${winner.name} won ${state.name} getting ${state.votes} votes with a $winChance% win chance${winChance <= 30 ? ' (an upset)' : ''}.';
}
