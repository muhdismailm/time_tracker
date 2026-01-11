class TimeEntry {
  final String id;
  final String taskName;
  final DateTime startTime;
  final DateTime endTime;

  TimeEntry({
    required this.id,
    required this.taskName,
    required this.startTime,
    required this.endTime,
  });

  /// Convert TimeEntry object → Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  /// Convert Map → TimeEntry object (from local storage)
  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'],
      taskName: map['taskName'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }
}
