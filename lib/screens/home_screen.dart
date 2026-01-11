import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/time_provider.dart';
import '../providers/project_provider.dart';
import '../models/time_entry.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate; // 📅 filter
  String searchQuery = ''; // 🔍 search

  @override
  Widget build(BuildContext context) {
    final timeProvider = context.watch<TimeProvider>();
    final projectProvider = context.watch<ProjectProvider>();

    List<TimeEntry> entries = timeProvider.entries;

    // 🔍 Search filter
    if (searchQuery.isNotEmpty) {
      entries = entries
          .where((e) =>
              e.taskName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // 📅 Date filter
    if (selectedDate != null) {
      entries = entries
          .where((e) =>
              e.startTime.year == selectedDate!.year &&
              e.startTime.month == selectedDate!.month &&
              e.startTime.day == selectedDate!.day)
          .toList();
    }

    // 📊 Total time
    final totalMinutes = entries.fold<int>(
      0,
      (sum, e) =>
          sum + e.endTime.difference(e.startTime).inMinutes,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Time Tracker'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work_outline),
                text: 'Projects & Tasks',
              ),
              Tab(
                icon: Icon(Icons.timer_outlined),
                text: 'Time Entries',
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              tooltip: 'Filter by Date',
              onPressed: _pickDate,
            ),
          ],
        ),

        drawer: const AppDrawer(),

        body: TabBarView(
          children: [
            // ================= TAB 1: PROJECTS & TASKS =================
            projectProvider.activeProjects.isEmpty
                ? const Center(child: Text('No projects added'))
                : ListView(
                    children: projectProvider.activeProjects.map((project) {
                      final tasks = projectProvider
                          .tasksByProject(project.id);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            radius: 6,
                            backgroundColor: project.color,
                          ),
                          title: Text(project.name),
                          subtitle:
                              Text('Tasks: ${tasks.length}'),
                          children: tasks.isEmpty
                              ? const [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text('No tasks'),
                                  )
                                ]
                              : tasks
                                  .map(
                                    (t) => ListTile(
                                      dense: true,
                                      title: Text(t.name),
                                      trailing: Text(
                                        t.priority.name
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      );
                    }).toList(),
                  ),

            // ================= TAB 2: TIME ENTRIES =================
            Column(
              children: [
                // 🔍 Search box
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by task name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),

                // 📊 Total time
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Total Time: $totalMinutes mins',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(),

                Expanded(
                  child: entries.isEmpty
                      ? const Center(
                          child: Text('No entries found'),
                        )
                      : ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (_, i) {
                            final e = entries[i];
                            final duration =
                                e.endTime
                                    .difference(e.startTime)
                                    .inMinutes;

                            return Card(
                              margin:
                                  const EdgeInsets.all(8),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.timer),
                                title: Text(e.taskName),
                                subtitle: Text(
                                    'Duration: $duration mins'),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<TimeProvider>()
                                        .deleteEntry(e.id);

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Time entry deleted'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, '/entry'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
