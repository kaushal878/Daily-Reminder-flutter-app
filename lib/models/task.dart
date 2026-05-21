import 'package:flutter/material.dart';

enum TaskCategory { personal, study, work, health, custom }
enum RepeatType { once, daily, weekly }
enum TaskPriority { low, medium, high }

class Task {
  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dateTime,
    this.category = TaskCategory.personal,
    this.repeatType = RepeatType.once,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    this.colorValue,
  });

  final String id;
  String title;
  String description;
  DateTime dateTime;
  TaskCategory category;
  RepeatType repeatType;
  TaskPriority priority;
  bool isCompleted;
  int? colorValue;

  Color get color => Color(colorValue ?? Colors.blue.value);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'category': category.name,
        'repeatType': repeatType.name,
        'priority': priority.name,
        'isCompleted': isCompleted,
        'colorValue': colorValue,
      };

  factory Task.fromMap(Map map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        dateTime: DateTime.parse(map['dateTime'] as String),
        category: TaskCategory.values.firstWhere(
          (e) => e.name == map['category'],
          orElse: () => TaskCategory.personal,
        ),
        repeatType: RepeatType.values.firstWhere(
          (e) => e.name == map['repeatType'],
          orElse: () => RepeatType.once,
        ),
        priority: TaskPriority.values.firstWhere(
          (e) => e.name == map['priority'],
          orElse: () => TaskPriority.medium,
        ),
        isCompleted: map['isCompleted'] as bool? ?? false,
        colorValue: map['colorValue'] as int?,
      );
}
