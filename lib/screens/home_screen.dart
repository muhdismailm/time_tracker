import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/time_provider.dart';
import '../providers/project_provider.dart';
import '../models/time_entry.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timeProvider = context.watch<TimeProvider>();
    final projectProvider = context.watch<ProjectProvider>();

    final entries = timeProvider.entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
      ),

      // ✅ Navigation Drawer
      drawer: const AppDrawer(),

      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No time entries yet',
                style: TextStyle(fontSize: 16),
              ),
            )
          : _buildGroupedList(
              context,
              entries,
              projectProvider,
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/entry'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------------- GROUPED LIST ----------------
  Widget _buildGroupedList(
    BuildContext context,
    List<TimeEntry> entries,
    ProjectProvider projectProvider,
  ) {
    // 🔹 Group entries by projectId
    final Map<String, List<TimeEntry>> grouped = {};

    for (final entry in entries) {
      grouped.putIfAbsent(entry.projectId, () => []);
      grouped[entry.projectId]!.add(entry);
    }

    return ListView(
      children: grouped.entries.map((group) {
        // 🔹 Find project (safe fallback)
        final project = projectProvider.activeProjects
            .where((p) => p.id == group.key)
            .cast()
            .firstWhere(
              (_) => true,
              orElse: () => null,
            );

        final projectName =
            project == null ? 'Unknown Project' : project.name;

        final projectColor =
            project == null ? Colors.grey : project.color;

        final projectEntries = group.value;

        // 🔹 Calculate total time per project
        final totalMinutes = projectEntries.fold<int>(
          0,
          (sum, e) =>
              sum + e.endTime.difference(e.startTime).inMinutes,
        );

        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: projectColor,
            ),
            title: Text(projectName),
            subtitle: Text('Total: $totalMinutes mins'),
            children: projectEntries.map((e) {
              final duration =
                  e.endTime.difference(e.startTime).inMinutes;

              return ListTile(
                title: Text(e.taskName),
                subtitle: Text('Duration: $duration mins'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context
                        .read<TimeProvider>()
                        .deleteEntry(e.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Time entry deleted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
