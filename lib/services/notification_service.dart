import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initDarwin = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: initAndroid, iOS: initDarwin),
    );
  }

  Future<void> scheduleTask(Task task) async {
    final details = const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_reminder_channel',
        'Daily Reminder',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final tzDate = tz.TZDateTime.from(task.dateTime, tz.local);

    await _plugin.zonedSchedule(
      task.id.hashCode,
      task.title,
      task.description.isEmpty ? 'Reminder for your task' : task.description,
      tzDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: switch (task.repeatType) {
        RepeatType.once => null,
        RepeatType.daily => DateTimeComponents.time,
        RepeatType.weekly => DateTimeComponents.dayOfWeekAndTime,
      },
    );
  }

  Future<void> cancelTask(String taskId) async {
    await _plugin.cancel(taskId.hashCode);
  }
}
