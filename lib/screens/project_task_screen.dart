import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';
import '../models/task.dart';
import '../widgets/app_drawer.dart';

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Projects & Tasks')),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProject(context),
        child: const Icon(Icons.add),
      ),
      body: provider.activeProjects.isEmpty
          ? const Center(child: Text('No projects added'))
          : ListView(
              children: provider.activeProjects.map((project) {
                final tasks = provider.tasksByProject(project.id);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    leading: CircleAvatar(backgroundColor: project.color),
                    title: Text(project.name),
                    subtitle: Text('Target: ${project.targetHours} hrs'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _confirmDeleteProject(context, project.id),
                    ),
                    children: [
                      ...tasks.map(
                        (task) => ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => context
                                .read<ProjectProvider>()
                                .toggleTask(task.id),
                          ),
                          title: Text(
                            task.name,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle:
                              Text(task.priority.name.toUpperCase()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _editTask(context, task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    _deleteTaskWithUndo(context, task),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _addTask(context, project.id),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ================= DELETE PROJECT =================
  void _confirmDeleteProject(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text(
            'This will delete the project and all its tasks. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectProvider>().deleteProject(projectId);
              Navigator.pop(context);
            },
            child:
                const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ================= UNDO DELETE TASK =================
  void _deleteTaskWithUndo(BuildContext context, Task task) {
    context.read<ProjectProvider>().deleteTask(task.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            context.read<ProjectProvider>().addTask(
                  task.projectId,
                  task.name,
                  task.priority,
                );
          },
        ),
      ),
    );
  }

  // ================= EDIT TASK =================
  void _editTask(BuildContext context, Task task) {
    final ctrl = TextEditingController(text: task.name);
    TaskPriority priority = task.priority;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: ctrl),
            DropdownButton<TaskPriority>(
              value: priority,
              items: TaskPriority.values
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (v) => priority = v!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<ProjectProvider>()
                  .editTask(task.id, ctrl.text, priority);
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  // ================= ADD PROJECT =================
  void _addProject(BuildContext context) {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProjectProvider>().addProject(
                    nameCtrl.text,
                    Colors.indigo,
                    int.tryParse(targetCtrl.text) ?? 0,
                  );
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  // ================= ADD TASK =================
  void _addTask(BuildContext context, String projectId) {
    final ctrl = TextEditingController();
    TaskPriority priority = TaskPriority.medium;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: ctrl),
            DropdownButton<TaskPriority>(
              value: priority,
              items: TaskPriority.values
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (v) => priority = v!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<ProjectProvider>()
                  .addTask(projectId, ctrl.text, priority);
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}
