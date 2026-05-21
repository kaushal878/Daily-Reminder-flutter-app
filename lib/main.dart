import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  final notifications = NotificationService();
  await notifications.init();

  final taskProvider = TaskProvider(storage, notifications);
  await taskProvider.loadTasks();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(MyApp(taskProvider: taskProvider, themeProvider: themeProvider));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.taskProvider, required this.themeProvider});
  final TaskProvider taskProvider;
  final ThemeProvider themeProvider;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.taskProvider),
        ChangeNotifierProvider.value(value: widget.themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Reminder',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme.themeMode,
          home: Scaffold(
            body: [const HomeScreen(), const CalendarScreen(), const SettingsScreen()][index],
            bottomNavigationBar: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) => setState(() => index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Calendar'),
                NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
