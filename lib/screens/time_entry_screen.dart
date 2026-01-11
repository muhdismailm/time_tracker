import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/time_provider.dart';
import '../models/time_entry.dart';

class TimeEntryScreen extends StatefulWidget {
  const TimeEntryScreen({super.key});

  @override
  State<TimeEntryScreen> createState() => _TimeEntryScreenState();
}

class _TimeEntryScreenState extends State<TimeEntryScreen> {
  final TextEditingController taskController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  /// Open clock-based time picker
  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  /// Combine Date + TimeOfDay → DateTime
  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  /// Save entry locally
  void _saveEntry() {
    if (startTime == null || endTime == null) return;

    final start = _combine(selectedDate, startTime!);
    final end = _combine(selectedDate, endTime!);

    // Validation
    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
        ),
      );
      return;
    }

    context.read<TimeProvider>().addEntry(
          TimeEntry(
            id: DateTime.now().toString(),
            taskName:
                taskController.text.isEmpty ? 'Unnamed Task' : taskController.text,
            startTime: start,
            endTime: end,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Task name
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            /// Start time
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text(
                startTime == null
                    ? 'Select Start Time'
                    : 'Start Time: ${startTime!.format(context)}',
              ),
              onTap: () => _pickTime(true),
            ),

            /// End time
            ListTile(
              leading: const Icon(Icons.stop),
              title: Text(
                endTime == null
                    ? 'Select End Time'
                    : 'End Time: ${endTime!.format(context)}',
              ),
              onTap: () => _pickTime(false),
            ),

            const SizedBox(height: 30),

            /// Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Entry'),
                onPressed: _saveEntry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
