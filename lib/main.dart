import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/time_provider.dart';
import 'providers/project_provider.dart';

import 'screens/home_screen.dart';
import 'screens/time_entry_screen.dart';
import 'screens/project_task_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TimeProvider()..loadEntries(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider()..load(),
        ),
      ],
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
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/entry': (_) => const TimeEntryScreen(),
        '/projects': (_) => const ProjectTaskScreen(),
      },
    );
  }
}
