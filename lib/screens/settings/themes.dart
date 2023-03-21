import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme_provider.dart';

class themes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Notifications",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Light Theme'),
            leading: Radio<ThemeModeOption>(
              value: ThemeModeOption.light,
              groupValue: themeProvider.themeMode.toThemeModeOption(),
              onChanged: (ThemeModeOption? value) {
                themeProvider.setThemeMode(value!);
              },
            ),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            leading: Radio<ThemeModeOption>(
              value: ThemeModeOption.dark,
              groupValue: themeProvider.themeMode.toThemeModeOption(),
              onChanged: (ThemeModeOption? value) {
                themeProvider.setThemeMode(value!);
              },
            ),
          ),
          ListTile(
            title: const Text('System Theme'),
            leading: Radio<ThemeModeOption>(
              value: ThemeModeOption.system,
              groupValue: themeProvider.themeMode.toThemeModeOption(),
              onChanged: (ThemeModeOption? value) {
                themeProvider.setThemeMode(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on ThemeMode {
  ThemeModeOption toThemeModeOption() {
    switch (this) {
      case ThemeMode.light:
        return ThemeModeOption.light;
      case ThemeMode.dark:
        return ThemeModeOption.dark;
      case ThemeMode.system:
      default:
        return ThemeModeOption.system;
    }
  }
}
