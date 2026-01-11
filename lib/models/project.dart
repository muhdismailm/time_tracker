import 'package:flutter/material.dart';

class Project {
  final String id;
  String name;
  Color color;
  int targetHours;
  bool isArchived; // ✅ REQUIRED FIELD

  Project({
    required this.id,
    required this.name,
    required this.color,
    this.targetHours = 0,
    this.isArchived = false, // ✅ DEFAULT VALUE
  });

  /// Convert Project → Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'targetHours': targetHours,
      'isArchived': isArchived,
    };
  }

  /// Convert Map → Project
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      targetHours: map['targetHours'] ?? 0,
      isArchived: map['isArchived'] ?? false,
    );
  }
}
