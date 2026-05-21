import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});
  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late DateTime _dateTime;
  TaskCategory _category = TaskCategory.personal;
  RepeatType _repeat = RepeatType.once;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = TextEditingController(text: task?.title ?? '');
    _description = TextEditingController(text: task?.description ?? '');
    _dateTime = task?.dateTime ?? DateTime.now().add(const Duration(hours: 1));
    _category = task?.category ?? _category;
    _repeat = task?.repeatType ?? _repeat;
    _priority = task?.priority ?? _priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(controller: _description, decoration: const InputDecoration(labelText: 'Description')),
            DropdownButtonFormField<TaskCategory>(
              initialValue: _category,
              items: TaskCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            DropdownButtonFormField<RepeatType>(
              initialValue: _repeat,
              items: RepeatType.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _repeat = v ?? _repeat),
              decoration: const InputDecoration(labelText: 'Repeat'),
            ),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              items: TaskPriority.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _priority = v ?? _priority),
              decoration: const InputDecoration(labelText: 'Priority'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.pop(
                  context,
                  Task(
                    id: widget.task?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                    title: _title.text.trim(),
                    description: _description.text.trim(),
                    dateTime: _dateTime,
                    category: _category,
                    repeatType: _repeat,
                    priority: _priority,
                    colorValue: Colors.primaries[_priority.index * 3].value,
                    isCompleted: widget.task?.isCompleted ?? false,
                  ),
                );
              },
              child: const Text('Save Task'),
            )
          ],
        ),
      ),
    );
  }
}
