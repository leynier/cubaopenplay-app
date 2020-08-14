import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    accentColor: Colors.red,
  );
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.blue.withOpacity(0.75),
  );
}
