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

  static AppThemeType getThemeType(String name) {
    switch (name) {
      case 'light':
        return AppThemeType.light;
      case 'dark':
        return AppThemeType.dark;
      default:
        return AppThemeType.dark;
    }
  }
}

enum AppThemeType { light, dark }

extension AppThemeTypeExtensor on AppThemeType {
  ThemeData get theme {
    switch (this) {
      case AppThemeType.light:
        return AppTheme.light;
      case AppThemeType.dark:
        return AppTheme.dark;
      default:
        return AppTheme.dark;
    }
  }

  String get name {
    switch (this) {
      case AppThemeType.light:
        return 'light';
      case AppThemeType.dark:
        return 'dark';
      default:
        return 'dark';
    }
  }
}
