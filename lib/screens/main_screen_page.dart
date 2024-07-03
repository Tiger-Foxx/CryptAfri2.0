import 'package:cryptafri/screens/InvestissementScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'AddProductScreen.dart';
import 'SellsScreen.dart';
import 'HomeScreen.dart';
import 'InfosScreen.dart';

import 'SearchPage.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage(
      {super.key,
      this.param = 0}); // Paramètre optionnel avec valeur par défaut 0
  final int param;
  static final String routeName = 'main';

  @override
  State<MainScreenPage> createState() =>
      _MainScreenPageState(currentIndex: param);
}

class _MainScreenPageState extends State<MainScreenPage> {
  _MainScreenPageState({this.currentIndex = 0});
  @override
  int currentIndex;
  final pages = [
    const HomeScreen(),
    const AddProductScreen(),
    const InvestissementScreen(),
    InfosPage(),
  ];

  Widget build(BuildContext context) {
    try {
      firebaseApi().initNotifications();
    } on Exception catch (e) {
      // TODO
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        currentIndex: currentIndex ?? 0, // the index of the current icon
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        showUnselectedLabels: false,
        selectedItemColor: Color.fromARGB(255, 231, 179, 7),
        unselectedItemColor: Color.fromARGB(157, 53, 41, 7),
        items: const <BottomNavigationBarItem>[
          // the icons to display in the bottom navigation bar
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'vendre',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_rounded),
            label: 'Investissement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'informations',
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
