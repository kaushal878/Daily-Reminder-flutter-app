import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._storage, this._notifications);

  final StorageService _storage;
  final NotificationService _notifications;
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get completed => _tasks.where((t) => t.isCompleted).toList();
  List<Task> get pending => _tasks.where((t) => !t.isCompleted).toList();

  Future<void> loadTasks() async {
    _tasks
      ..clear()
      ..addAll(_storage.getTasks());
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _persist();
    await _notifications.scheduleTask(task);
  }

  Future<void> updateTask(Task updated) async {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    await _notifications.cancelTask(updated.id);
    await _notifications.scheduleTask(updated);
    await _persist();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _notifications.cancelTask(id);
    await _persist();
  }

  Future<void> toggleTask(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    await _persist();
  }

  Future<String> exportAsJson() async =>
      const JsonEncoder.withIndent('  ').convert(_tasks.map((e) => e.toMap()).toList());

  Future<void> _persist() async {
    await _storage.saveTasks(_tasks);
    notifyListeners();
  }
}
