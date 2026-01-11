import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<TimeProvider>().entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/projects'),
          ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(child: Text('No time entries yet'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final e = entries[i];
                final duration =
                    e.endTime.difference(e.startTime).inMinutes;
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(e.taskName),
                    subtitle: Text('Duration: $duration mins'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          context.read<TimeProvider>().deleteEntry(e.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/entry'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
