import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_provider.dart';
import '../models/time_entry.dart';

class TimeEntryScreen extends StatelessWidget {
  const TimeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<TimeProvider>().addEntry(
              TimeEntry(
                id: DateTime.now().toString(),
                taskName: 'Sample Task',
                startTime: DateTime.now().subtract(const Duration(hours: 1)),
                endTime: DateTime.now(),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Save Sample Entry'),
        ),
      ),
    );
  }
}
