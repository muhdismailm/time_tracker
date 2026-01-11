import 'package:flutter/material.dart';

class ProjectTaskScreen extends StatelessWidget {
  const ProjectTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects & Tasks')),
      body: const Center(
        child: Text('Manage projects and tasks here'),
      ),
    );
  }
}
