import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
