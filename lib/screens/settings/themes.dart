import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme_provider.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignore_for_file: camel_case_types

class themes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: themesPage(),
    );
  }
}

class themesPage extends StatefulWidget {
  const themesPage({Key? key}) : super(key: key);

  @override
  _ThemesState createState() => _ThemesState();
}

class _ThemesState extends State<themesPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Themes",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
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
                              groupValue:
                                  themeProvider.themeMode.toThemeModeOption(),
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
                              groupValue:
                                  themeProvider.themeMode.toThemeModeOption(),
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
                              groupValue:
                                  themeProvider.themeMode.toThemeModeOption(),
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
