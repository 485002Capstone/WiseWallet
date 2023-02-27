import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:WiseWallet/screens/home_settings.dart';
import 'package:flutter/material.dart';

class themes extends StatelessWidget {
  const themes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text("Themes",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.black))),
      body: const Center(
        child: ThemeSwitch(),
      )
    );
  }
}

enum themeChoices { light, dark, system }

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({super.key});

  @override
  State<ThemeSwitch> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<ThemeSwitch> {
  themeChoices? _character = themeChoices.light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Dark mode'),
          leading: Radio<themeChoices>(
            value: themeChoices.light,
            groupValue: _character,
            onChanged: (themeChoices? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Light mode'),
          leading: Radio<themeChoices>(
            value: themeChoices.dark,
            groupValue: _character,
            onChanged: (themeChoices? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('System'),
          leading: Radio<themeChoices>(
            value: themeChoices.system,
            groupValue: _character,
            onChanged: (themeChoices? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}