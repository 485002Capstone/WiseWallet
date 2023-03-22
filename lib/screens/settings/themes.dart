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
        title: const Text("Themes",
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
        children: [Card(
          margin: EdgeInsets.all(16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Select Theme',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Light Theme',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  leading: Radio<ThemeModeOption>(
                    value: ThemeModeOption.light,
                    groupValue: themeProvider.themeMode.toThemeModeOption(),
                    onChanged: (ThemeModeOption? value) {
                      themeProvider.setThemeMode(value!);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Dark Theme',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  leading: Radio<ThemeModeOption>(
                    value: ThemeModeOption.dark,
                    groupValue: themeProvider.themeMode.toThemeModeOption(),
                    onChanged: (ThemeModeOption? value) {
                      themeProvider.setThemeMode(value!);
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'System Theme',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
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
          ),
        )
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
