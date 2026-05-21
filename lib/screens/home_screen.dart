import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final today = provider.tasks.where((t) =>
        t.dateTime.year == DateTime.now().year &&
        t.dateTime.month == DateTime.now().month &&
        t.dateTime.day == DateTime.now().day &&
        t.title.toLowerCase().contains(query.toLowerCase()));

    final progress = provider.tasks.isEmpty
        ? 0.0
        : provider.completed.length / provider.tasks.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Reminder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TaskFormScreen()));
          if (task != null) {
            await provider.addTask(task);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search tasks...'),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LinearProgressIndicator(value: progress),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Completed: ${provider.completed.length} / ${provider.tasks.length}'),
          ),
          Expanded(
            child: today.isEmpty
                ? const Center(child: Text('No tasks today. Tap + to add one.'))
                : ListView(
                    children: today
                        .map((task) => TaskCard(
                              task: task,
                              onToggle: () => provider.toggleTask(task.id),
                              onEdit: () async {
                                final edited = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                                );
                                if (edited != null) await provider.updateTask(edited);
                              },
                              onDelete: () => provider.deleteTask(task.id),
                            ))
                        .toList(),
                  ),
          )
        ],
      ),
    );
  }
}
