import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';
import '../models/task.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];

  /// Active (non-archived) projects
  List<Project> get activeProjects =>
      _projects.where((p) => !p.isArchived).toList();

  /// Get tasks under a project
  List<Task> tasksByProject(String projectId) =>
      _tasks.where((t) => t.projectId == projectId).toList();

  /// Load projects & tasks from local storage
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final projectData = prefs.getString('projects');
    final taskData = prefs.getString('tasks');

    if (projectData != null) {
      _projects = (jsonDecode(projectData) as List)
          .map((e) => Project.fromMap(e))
          .toList();
    }

    if (taskData != null) {
      _tasks = (jsonDecode(taskData) as List)
          .map((e) => Task.fromMap(e))
          .toList();
    }

    notifyListeners();
  }

  /// Add new project
  Future<void> addProject(String name, Color color, int targetHours) async {
    _projects.add(
      Project(
        id: DateTime.now().toString(),
        name: name,
        color: color,
        targetHours: targetHours,
      ),
    );
    await _save();
  }

  /// Edit existing project
  Future<void> editProject(Project project, String newName, int targetHours) async {
    project.name = newName;
    project.targetHours = targetHours;
    await _save();
  }

  /// Archive / Unarchive project
  Future<void> archiveProject(Project project) async {
    project.isArchived = !project.isArchived;
    await _save();
  }

  /// Add task to a project
  Future<void> addTask(
      String projectId, String name, TaskPriority priority) async {
    _tasks.add(
      Task(
        id: DateTime.now().toString(),
        projectId: projectId,
        name: name,
        priority: priority,
      ),
    );
    await _save();
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    await _save();
  }

  /// Save to SharedPreferences
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      'projects',
      jsonEncode(_projects.map((e) => e.toMap()).toList()),
    );

    prefs.setString(
      'tasks',
      jsonEncode(_tasks.map((e) => e.toMap()).toList()),
    );

    notifyListeners();
  }
}
