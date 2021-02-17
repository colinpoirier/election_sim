import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class States {
  States({
    this.states,
  });

  final List<StateData> states;

  bool get isValid {
    final statesVotes = states.map((e) => e.votes).toList();
    return statesVotes.every((votes) => votes >= 0);
  }


  List<Map<String, dynamic>> toMap() {
    return states?.map((x) => x?.toMap())?.toList();
  }

  String toJson() => json.encode(toMap());

  factory States.fromMap(List<Map<String, dynamic>> maps) {
    if (maps == null) return null;
  
    return States(
      states: List<StateData>.from(maps.map((x) => StateData.fromMap(x))),
    );
  }

  factory States.fromJson(String source) => States.fromMap(List<Map<String, dynamic>>.from(json.decode(source)));

  @override
  String toString() => 'States(states: $states)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is States &&
      listEquals(o.states, states);
  }

  @override
  int get hashCode => hashList([states.hashCode]);
}

class StateData {
  StateData({
    this.id,
    this.name,
    this.votes,
  });

  final int id;
  final String name;
  final int votes;

  factory StateData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return StateData(
      id: map['id'],
      name: map['name'],
      votes: map['votes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'votes': votes,
    };
  }

  String toJson() => json.encode(toMap());

  factory StateData.fromJson(String source) => StateData.fromMap(json.decode(source));

  @override
  String toString() => 'StateData(id: $id, name: $name, votes: $votes)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is StateData &&
      o.id == id &&
      o.name == name &&
      o.votes == votes;
  }

  @override
  int get hashCode => hashList([id, name, votes]);

}
