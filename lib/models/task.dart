enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String projectId;
  String name;
  TaskPriority priority;
  bool isCompleted; // ✅ NEW

  Task({
    required this.id,
    required this.projectId,
    required this.name,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'priority': priority.name,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['projectId'],
      name: map['name'],
      priority: TaskPriority.values
          .firstWhere((e) => e.name == map['priority']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
