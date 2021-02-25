import 'dart:convert';

import 'overall_results/overall_results.dart';
import 'election_results.dart';

export 'election_results.dart';
export 'overall_results/overall_results.dart';

class RunResults {
  RunResults({
    this.electionResults,
    this.overallResult,
    this.run,
  }) : formatted = getFormatted(electionResults, overallResult, run);

  final List<ElectionResults> electionResults;
  final OverallResult overallResult;
  final int run;
  final String formatted;
  
  static String getFormatted(List<ElectionResults> electionResults, OverallResult overallResult, int run) {
    final buffer = StringBuffer();
    buffer.writeln('Run $run:');
    for (final er in electionResults) {
      buffer.writeln(er.formatted());
    }
    buffer.writeln(overallResult.formatted());
    return buffer.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'electionResults': electionResults?.map((x) => x?.toMap())?.toList(),
      'overallResult': overallResult?.toMap(),
      'run': run,
    };
  }

  factory RunResults.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return RunResults(
      electionResults: List<ElectionResults>.from(map['electionResults']?.map((x) => ElectionResults.fromMap(x))),
      overallResult: OverallResult.fromMap(map['overallResult']),
      run: map['run'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RunResults.fromJson(String source) => RunResults.fromMap(json.decode(source));

  @override
  String toString() => 'RunResults(electionResults: $electionResults, overallResult: $overallResult, run: $run)';
}







