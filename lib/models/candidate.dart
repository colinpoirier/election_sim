import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Candidates {
  Candidates({
    this.candidates,
  });

  final List<Candidate> candidates;

  bool get haveSameStates {
    // check if all candidates have same states
    final listsOfStateIds = candidates.map((e) => e.stateChancesOfWinning.map((e) => e.stateId).toList()).toList();
    if (listsOfStateIds.isEmpty) return false;
    final firstList = listsOfStateIds.first;
    for (int i = 1; i < listsOfStateIds.length; i++) {
      if (!listEquals(firstList, listsOfStateIds[i])) {
        return false;
      }
    }
    return true;
  }

  bool get haveValidChances {
    // check to make sure sum of chances == 100
    final listsOfChances = candidates.map((e) => e.stateChancesOfWinning.map((e) => e.chance).toList()).toList();
    for (int j = 0; j < listsOfChances.first.length; j++) {
      int sumChance = 0;
      for (int i = 0; i < listsOfChances.length; i++) {
        sumChance += listsOfChances[i][j];
      }
      if (sumChance != 100) return false;
    }
    return true;
  }

  Candidates copyWith({
    List<Candidate> candidates,
  }) {
    return Candidates(
      candidates: candidates ?? this.candidates,
    );
  }

  List<Map<String, dynamic>> toMap() {
    return candidates?.map((x) => x?.toMap())?.toList();
  }

  String toJson() => json.encode(toMap());

  factory Candidates.fromMap(List<Map<String, dynamic>> maps) {
    if (maps == null) return null;

    return Candidates(
      candidates: List<Candidate>.from(maps.map((x) => Candidate.fromMap(x))),
    );
  }

  factory Candidates.fromJson(String source) =>
      Candidates.fromMap(List<Map<String, dynamic>>.from(json.decode(source)));

  @override
  String toString() => 'Candidates(candidates: $candidates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Candidates && listEquals(o.candidates, candidates);
  }

  @override
  int get hashCode => hashList([candidates.hashCode]);
}

class Candidate {
  Candidate({
    this.id,
    this.name,
    this.stateChancesOfWinning,
  });

  final int id;
  final String name;
  final List<StateChancesOfWinning> stateChancesOfWinning;

  Candidate copyWith({
    int id,
    String name,
    List<StateChancesOfWinning> stateChancesOfWinning,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      stateChancesOfWinning: stateChancesOfWinning ?? this.stateChancesOfWinning,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state_chances_of_winning': stateChancesOfWinning?.map((x) => x?.toMap())?.toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Candidate.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Candidate(
      id: map['id'],
      name: map['name'],
      stateChancesOfWinning: List<StateChancesOfWinning>.from(
          map['state_chances_of_winning']?.map((x) => StateChancesOfWinning.fromMap(x))),
    );
  }

  factory Candidate.fromJson(String source) => Candidate.fromMap(json.decode(source));

  @override
  String toString() => 'Candidate(id: $id, name: $name, stateChancesOfWinning: $stateChancesOfWinning)';

  @override
  bool operator ==(Object o) {
    if (o == null) return false;
    if (identical(this, o)) return true;

    return o is Candidate && o.id == id && o.name == name && listEquals(o.stateChancesOfWinning, stateChancesOfWinning);
  }

  @override
  int get hashCode => hashList([id, name, stateChancesOfWinning.hashCode]);
}

class StateChancesOfWinning {
  StateChancesOfWinning({
    this.stateId,
    this.chance,
  });

  final int stateId;
  final int chance;

  StateChancesOfWinning copyWith({
    int stateId,
    int chance,
  }) {
    return StateChancesOfWinning(
      stateId: stateId ?? this.stateId,
      chance: chance ?? this.chance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state_id': stateId,
      'chance': chance,
    };
  }

  String toJson() => json.encode(toMap());

  factory StateChancesOfWinning.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return StateChancesOfWinning(
      stateId: map['state_id'],
      chance: map['chance'],
    );
  }

  factory StateChancesOfWinning.fromJson(String source) => StateChancesOfWinning.fromMap(json.decode(source));

  @override
  String toString() => 'StateChancesOfWinning(stateId: $stateId, chance: $chance)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StateChancesOfWinning && o.stateId == stateId && o.chance == chance;
  }

  @override
  int get hashCode => hashList([stateId, chance]);
}
