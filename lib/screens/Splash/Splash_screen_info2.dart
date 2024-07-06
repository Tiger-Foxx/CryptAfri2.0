import 'package:cryptafri/screens/forms/AddProductScreen.dart';
import 'package:cryptafri/screens/home/HomeScreen.dart';
import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:cryptafri/screens/InfosScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../onboarding_screen.dart';

class Splash_screen_info2 extends StatefulWidget {
  static const routeName = 'splash_info2';
  const Splash_screen_info2({super.key});

  @override
  State<Splash_screen_info2> createState() => _Splash_screen_info2State();
}

class _Splash_screen_info2State extends State<Splash_screen_info2> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 60), () {
      Navigator.pushReplacement(context, _createRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      "POUR FINALISER VOTRE TRANSACTION,\n VOUS DEVEZ  EFFECTUER UN DEPOT SUR NOTRE COMPTE OM OU MTN MONEY \n (les NUMEROS sont aussi disponibles dans la section INFO)",
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
                        "Veuillez patienter quelques minutes, Vous Recevrez Votre Depot Apres que vous Ayez termine la transaction,\nChoisissez le reseau de Transfert ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 182, 177, 177),
                            fontFamily: 'Poppins',
                            fontSize: 14),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Attention veillez nous contacter pour négocier des crypto-monnaies non listées sur la plateforme.\nCryptAfri ne vous contactera jamais en premier",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 221, 93, 2)),
                        onPressed: () async {
                          await FirebaseApi().sendAchatNotif();
                          Navigator.pushReplacement(context, _createRoute());
                          sendMsg("#150*1*1*" + InfosPage.OM + "#");
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/OM.png',
                                height: 35,
                                width: 35,
                              ),
                              Text(
                                'ORANGE MONEY',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 221, 166, 2)),
                        onPressed: () async {
                          await FirebaseApi().sendAchatNotif();
                          Navigator.pushReplacement(context, _createRoute());
                          sendMsg("*126#");
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/MOMO.png',
                                height: 35,
                                width: 35,
                              ),
                              Text(
                                'MTN MOMO',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

  void sendMsg(String Msg) {
    var number = Uri.encodeComponent(Msg);
    // Encoder le message

    // Construire l'URL
    String url = 'tel:$number';

    // Lancer l'URL
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch URL: $e');
    }
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
