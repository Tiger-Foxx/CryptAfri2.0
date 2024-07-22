import 'package:cryptafri/screens/admin/AddMessageScreen.dart';
import 'package:cryptafri/screens/InvestissementScreen.dart';
import 'package:cryptafri/screens/ViewMessageScreen.dart';
import 'package:cryptafri/screens/admin/distributionScreen.dart';
import 'package:cryptafri/screens/infosLiens.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:cryptafri/screens/admin/transactionsScreen.dart';
import 'package:flutter/material.dart';
import 'forms/AddProductScreen.dart';
import 'SellsScreen.dart';
import 'home/HomeScreen.dart';
import 'InfosScreen.dart';

import 'SearchPage.dart';

class MainScreenPage_client extends StatefulWidget {
  const MainScreenPage_client(
      {super.key,
      this.param = 0}); // Paramètre optionnel avec valeur par défaut 0
  final int param;
  static final String routeName = 'mainClient';

  @override
  State<MainScreenPage_client> createState() =>
      _MainScreenPage_clientState(currentIndex: param);
}

class _MainScreenPage_clientState extends State<MainScreenPage_client> {
  _MainScreenPage_clientState({this.currentIndex = 0});
  @override
  int currentIndex;
  final pages = [
    const HomeScreen(),
    const AddProductScreen(),
    const InvestissementScreen(),
    MessageFeedPage(),
    LienScreen(),
    InfosPage(),
  ];

  Widget build(BuildContext context) {
    try {
      FirebaseApi().initNotifications();
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
            label: 'Vendre',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_rounded),
            label: 'Investissement',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'News',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.telegram,
              color: Colors.blue,
            ),
            label: 'liens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Informations',
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
