import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      );
}
