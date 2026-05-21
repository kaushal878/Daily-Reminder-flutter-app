import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(color: Colors.orange),
      secondaryBackground: Container(color: Colors.red),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        }
        onDelete();
        return true;
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(value: task.isCompleted, onChanged: (_) => onToggle()),
          title: Text(task.title),
          subtitle: Text(DateFormat.yMMMd().add_jm().format(task.dateTime)),
          trailing: Icon(Icons.flag, color: task.color),
        ),
      ),
    );
  }
}
