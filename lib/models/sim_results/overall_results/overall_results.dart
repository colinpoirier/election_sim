import '../../candidate.dart';
import 'one_winner.dart';
import 'tie_winners.dart';

export 'one_winner.dart';
export 'tie_winners.dart';

abstract class OverallResult {
  OverallResult();
  factory OverallResult.fromWinners({List<Candidate> winners, int votes}){
    if(winners.length == 1){
      return OneWinner(winner: winners.first, votes: votes);
    }
    return TieWinners(winners: winners, votes: votes);
  }

  factory OverallResult.fromMap(Map<String, dynamic> map){
    return OneWinner.fromMap(map) ?? TieWinners.fromMap(map);
  }


  Map<String, dynamic> toMap();

  String formatted();
}