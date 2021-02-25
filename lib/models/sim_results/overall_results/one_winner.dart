import 'dart:convert';

import 'package:election_sim/models/candidate.dart';

import 'overall_results.dart';

class OneWinner extends OverallResult {
  OneWinner({
    this.winner,
    this.votes,
  });
  final Candidate winner;
  final int votes;

  Map<String, dynamic> toMap() {
    return {
      'winner': winner?.toMap(),
      'votes': votes,
    };
  }

  factory OneWinner.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OneWinner(
      winner: Candidate.fromMap(map['winner']),
      votes: map['votes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OneWinner.fromJson(String source) => OneWinner.fromMap(json.decode(source));

  @override
  String toString() => 'OneWinner(winner: $winner, votes: $votes)';

  @override
  String formatted() {
    return 'Overall winner is ${winner.name} with $votes votes.';
  }
}
