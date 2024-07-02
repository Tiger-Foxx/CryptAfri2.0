import 'package:cryptafri/screens/InvestissementScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'AddProductScreen.dart';
import 'SellsScreen.dart';
import 'HomeScreen.dart';
import 'InfosScreen.dart';

import 'SearchPage.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});
  static final String routeName = 'main';

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> {
  @override
  int _currentIndex = 0;
  final pages = [
    const HomeScreen(),
    const AddProductScreen(),
    ProfilePage(),
    const InvestissementScreen(),
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
        currentIndex: _currentIndex, // the index of the current icon
        onTap: (index) {
          setState(() => _currentIndex = index);
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
            icon: Icon(Icons.info),
            label: 'informations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_rounded),
            label: 'Investissement',
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }
}
