enum TaskPriority { high, medium, low }

class Task {
  final String id;
  final String projectId;
  String name;
  TaskPriority priority; // ✅ REQUIRED FIELD

  Task({
    required this.id,
    required this.projectId,
    required this.name,
    this.priority = TaskPriority.medium, // ✅ DEFAULT
  });

  /// Convert Task → Map (for local storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'priority': priority.index,
    };
  }

  /// Convert Map → Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['projectId'],
      name: map['name'],
      priority: TaskPriority.values[
          map['priority'] ?? TaskPriority.medium.index],
    );
  }
}
