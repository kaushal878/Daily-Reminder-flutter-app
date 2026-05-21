import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final daily = tasks.where((t) => isSameDay(t.dateTime, selectedDay)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2100),
            focusedDay: selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, selectedDay),
            onDaySelected: (selected, _) => setState(() => selectedDay = selected),
            eventLoader: (day) => tasks.where((t) => isSameDay(t.dateTime, day)).toList(),
          ),
          Expanded(
            child: ListView(
              children: daily
                  .map((t) => ListTile(title: Text(t.title), subtitle: Text(t.category.name)))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
