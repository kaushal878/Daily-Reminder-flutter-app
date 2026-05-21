import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final tasks = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: theme.themeMode == ThemeMode.dark,
            onChanged: (v) => theme.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
          ListTile(
            title: const Text('Export tasks as JSON'),
            subtitle: const Text('Preview JSON export'),
            onTap: () async {
              final json = await tasks.exportAsJson();
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(content: SingleChildScrollView(child: Text(json))));
              }
            },
          ),
        ],
      ),
    );
  }
}
