import 'package:flutter/material.dart';
import 'package:phixlab_money/screens/home_page.dart';
import 'package:phixlab_money/screens/home_settings.dart';
import 'package:phixlab_money/screens/home_tips.dart';
import 'package:phixlab_money/screens/home_wallet.dart';
import 'package:phixlab_money/utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainScreen> {
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const homepage();
      case 1:
        return homewallet();
      case 2:
        return hometips();
      case 3:
        return const homesettings();
      default:
        return const homepage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: secondaryDark,
        unselectedItemColor: fontLight,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/home.png"), label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/wallet.png"), label: "Wallet"),
          // BottomNavigationBarItem(
          //   icon: Image.asset("assets/icons/plus.png"), label: "Plus"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/bulb.png"), label: "Tips"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/settings.png"),
              label: "Settings"),
        ],
      ),
    );
  }
}
