import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/time_provider.dart';
import 'screens/home_screen.dart';
import 'screens/time_entry_screen.dart';
import 'screens/project_task_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimeProvider()..loadEntries(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: Colors.grey.shade100,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),

        // ✅ FIX: CardThemeData (NOT CardTheme)
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      routes: {
        '/': (_) => const HomeScreen(),
        '/entry': (_) => const TimeEntryScreen(),
        '/projects': (_) => const ProjectTaskScreen(),
      },
    );
  }
}
