import 'package:cryptafri/screens/AddProductScreen.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_screen.dart';

class Splash_screen_info extends StatefulWidget {
  static const routeName = 'splash_info1';
  const Splash_screen_info({super.key});

  @override
  State<Splash_screen_info> createState() => _Splash_screen_infoState();
}

class _Splash_screen_infoState extends State<Splash_screen_info> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6000), () {
      Navigator.pushReplacement(context, _createRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 42, 42, 43),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Lottie.asset('assets/lotties/bitcoin1.json', height: 200),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "POUR FINALISER VOTRE TRANSACTION,\n VOUS DEVEZ CLIQUER SUR VALIDER , PUIS , EFFECTUER LE DEPOT SUR NOTRE RESEAU D'EMSSION QUE VOUS AVEZ CHOISI\n (les addresses sont aussi disponibles dans la section INFO)",
                        style: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Copiez l'addresse du reseau que vous avez Choisi (" +
                              AddProductScreen.portefName +
                              ")",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CopyableTextButton(AddProductScreen.portef),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Veuillez vérifier que votre réseau d'émission est << " +
                              AddProductScreen.portefName +
                              " >> avant de valider ",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 7, 7),
                              fontFamily: 'Poppins',
                              fontSize: 17),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushReplacement(context, _createRoute());
                    await firebaseApi().sendVenteNotif();
                  },
                  child: Text('Valider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MainScreenPage(),
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
          SnackBar(
            content: Text('Texte copié'),
          ),
        );
      },
      icon: Icon(Icons.copy),
      label: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 19, color: Colors.amber)),
    );
  }
}
