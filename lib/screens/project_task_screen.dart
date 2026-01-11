import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/project_provider.dart';
import '../models/task.dart';
import '../widgets/app_drawer.dart'; // ✅ Drawer import

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Projects & Tasks'),
      ),

      // ✅ Navigation Drawer
      drawer: const AppDrawer(),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProject(context),
        child: const Icon(Icons.add),
      ),

      body: provider.activeProjects.isEmpty
          ? const Center(
              child: Text(
                'No projects added',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView(
              children: provider.activeProjects.map((project) {
                final tasks = provider.tasksByProject(project.id);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: project.color,
                    ),
                    title: Text(project.name),
                    subtitle:
                        Text('Target: ${project.targetHours} hrs'),
                    children: [
                      if (tasks.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('No tasks added'),
                        ),

                      ...tasks.map(
                        (task) => ListTile(
                          title: Text(task.name),
                          subtitle: Text(
                            task.priority.name.toUpperCase(),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context
                                  .read<ProjectProvider>()
                                  .deleteTask(task.id);

                              // ✅ SnackBar feedback
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text('Task deleted'),
                                  duration:
                                      Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () =>
                            _addTask(context, project.id),
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

  // ---------------- ADD PROJECT ----------------
  void _addProject(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Project Name'),
            ),
            TextField(
              controller: targetController,
              decoration:
                  const InputDecoration(labelText: 'Target Hours'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProjectProvider>().addProject(
                    nameController.text,
                    Colors.indigo,
                    int.tryParse(targetController.text) ?? 0,
                  );
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  // ---------------- ADD TASK ----------------
  void _addTask(BuildContext context, String projectId) {
    final taskController = TextEditingController();
    TaskPriority priority = TaskPriority.medium;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskController,
              decoration:
                  const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 10),
            DropdownButton<TaskPriority>(
              value: priority,
              isExpanded: true,
              items: TaskPriority.values
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        p.name.toUpperCase(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                priority = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProjectProvider>().addTask(
                    projectId,
                    taskController.text,
                    priority,
                  );
              Navigator.pop(context);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
}
