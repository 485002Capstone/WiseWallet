import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types
enum ThemeModeOption { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeModeOption themeOption) {
    switch (themeOption) {
      case ThemeModeOption.light:
        _themeMode = ThemeMode.light;
        break;
      case ThemeModeOption.dark:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeModeOption.system:
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
