import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔹 Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  'Time Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Track your productivity',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Menu Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Add Time Entry'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/entry');
            },
          ),

          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Projects & Tasks'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/projects');
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Close'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
