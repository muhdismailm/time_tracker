class TimeEntry {
  final String id;
  final String projectId;
  final String taskName;
  final DateTime startTime;
  final DateTime endTime;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskName,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'taskName': taskName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'] as String,
      projectId: map['projectId'] ?? 'default-project', // ✅ SAFE DEFAULT
      taskName: map['taskName'] as String,
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }
}
