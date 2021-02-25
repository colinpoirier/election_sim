import 'dart:convert';

import 'package:election_sim/models/candidate.dart';
import 'package:election_sim/models/sim_results/overall_results/overall_results.dart';

class TieWinners extends OverallResult {
  TieWinners({
    this.winners,
    this.votes,
  });
  final List<Candidate> winners;
  final int votes;

  Map<String, dynamic> toMap() {
    return {
      'winners': winners?.map((x) => x?.toMap())?.toList(),
      'votes': votes,
    };
  }

  factory TieWinners.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TieWinners(
      winners: List<Candidate>.from(map['winners']?.map((x) => Candidate.fromMap(x))),
      votes: map['votes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TieWinners.fromJson(String source) => TieWinners.fromMap(json.decode(source));

  @override
  String toString() => 'TieWinners(winners: $winners, votes: $votes)';

  @override
  String formatted() {
    final electionWinners = List<Candidate>.from(winners);
    final lastWinner = electionWinners.removeLast();
    final listWinners = electionWinners.map((e) => e.name).toString().replaceAll(RegExp(r'[\[|\]]'), '');
    return 'It was a tie between $listWinners${listWinners.length > 1 ? ',' : ''} and ${lastWinner.name} with $votes votes.';
  }
}
