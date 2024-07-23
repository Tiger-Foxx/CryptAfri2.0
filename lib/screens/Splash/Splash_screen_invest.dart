// ignore_for_file: camel_case_types

import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:cryptafri/screens/main_screen_page_client.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Splash_screen_invest extends StatefulWidget {
  static const routeName = 'splash_invest';
  const Splash_screen_invest({super.key});

  @override
  State<Splash_screen_invest> createState() => _Splash_screen_investState();
}

class _Splash_screen_investState extends State<Splash_screen_invest> {
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
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: 1200,
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
                              "INVESTISSEMENT SUR CRYPTAFRI !",
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
                              "POUR EFECTUER VOTRE INVESTISSEMENT, VOUS DEVREZ REMPLIR LE FORMULAIRE , ET ENSUITE EFFFECTUER UN DEPOT VIA MOMO , ORANGE MONEY , OU L'UNE DES ADDRESSES USDT PROPOSEE \n (SI L'INTEGRALITE DU MONTANT DE L'INVESTISSEMENT N'EST PAS ENVOYE , CELUI-CI SERA ANNULE)",
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
                        Navigator.pushNamed(context, 'investir');
                        //await firebaseApi().sendVenteNotif();
                      },
                      child: const Text('CONTINUER'),
                    ),
                  ],
                ),
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
          const MainScreenPage_client(),
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
