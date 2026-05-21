# Daily Reminder (Flutter)

Offline-first daily task reminder app with Material 3 UI.

## Features
- Add/edit/delete tasks with swipe actions
- Mark tasks complete, category/repeat/priority support
- Local notifications with timezone-aware scheduling
- Dashboard progress, today tasks, calendar view, search
- Light/dark mode persistence
- Export tasks as JSON

## Tech Stack
- Flutter + Dart (null-safe)
- Provider state management
- Hive local storage
- flutter_local_notifications + timezone
- table_calendar

## Setup
1. Install Flutter stable SDK.
2. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Build APK
```bash
flutter build apk --release
```

## Notes
- Notifications are canceled/rescheduled on task updates.
- App is fully local (no backend).
