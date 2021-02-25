import 'dart:convert';

import 'package:election_sim/models/sim_results/run_results.dart';

class SimResults {
  SimResults({this.results});

  final List<RunResults> results;

  Map<String, dynamic> toMap() {
    return {
      'results': results?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory SimResults.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SimResults(
      results: List<RunResults>.from(map['results']?.map((x) => RunResults.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SimResults.fromJson(String source) => SimResults.fromMap(json.decode(source));
}
