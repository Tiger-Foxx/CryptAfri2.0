// ignore_for_file: camel_case_types

import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Splash_screen_valider_retrait extends StatefulWidget {
  static const routeName = 'splash_valider_retrait';
  const Splash_screen_valider_retrait({super.key});

  @override
  State<Splash_screen_valider_retrait> createState() =>
      _Splash_screen_valider_retraitState();
}

class _Splash_screen_valider_retraitState
    extends State<Splash_screen_valider_retrait> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 60000), () {
      Navigator.pushReplacement(context, _createRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: Container(
            color: const Color.fromARGB(255, 42, 42, 43),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Lottie.asset('assets/lotties/bitcoin1.json', height: 200),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "RETRAIT SUR CRYPTAFRI !",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "RETRAIT VALIDE VOTRE ARGENT VOUS SERA ENVOYE avec des frais de 2%  A L'ADDRESSE QUE VOUS AUREZ SPECIFIE \n (VOUS LE RECEVREZ DANS UN INTERVALLE DE 6H MAXIMUM, EN CAS DE SOUCIS CONTACTEZ LE SERVICE CLIENT)",
                            style: TextStyle(
                              color: Colors.white54,
                              fontFamily: 'Poppins',
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, 'retrait');
                      await firebaseApi().sendRetaitNotif();
                    },
                    child: const Text('CONTINUER'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MainScreenPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

class CopyableTextButton extends StatelessWidget {
  final String text;

  CopyableTextButton(this.text);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Texte copié'),
          ),
        );
      },
      icon: const Icon(Icons.copy),
      label: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w900, fontSize: 19, color: Colors.amber)),
    );
  }
}
