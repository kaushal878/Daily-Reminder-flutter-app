import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';

class StorageService {
  static const boxName = 'tasks_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  Box get _box => Hive.box(boxName);

  List<Task> getTasks() => _box.values
      .map((value) => Task.fromMap(Map<String, dynamic>.from(value)))
      .toList();

  Future<void> saveTasks(List<Task> tasks) async {
    await _box.clear();
    for (final task in tasks) {
      await _box.put(task.id, task.toMap());
    }
  }
}
