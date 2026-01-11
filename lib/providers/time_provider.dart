import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/time_entry.dart';

class TimeProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  /// Getter for time entries
  List<TimeEntry> get entries => _entries;

  /// Load saved time entries from local storage
  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('time_entries');

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      _entries =
          decoded.map((e) => TimeEntry.fromMap(e)).toList();
      notifyListeners();
    }
  }

  /// Add new time entry
  Future<void> addEntry(TimeEntry entry) async {
    _entries.add(entry);
    notifyListeners();
    await _saveEntries();
  }

  /// Delete a time entry
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _saveEntries();
  }

  /// Save time entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'time_entries',
      jsonEncode(_entries.map((e) => e.toMap()).toList()),
    );
  }
}
