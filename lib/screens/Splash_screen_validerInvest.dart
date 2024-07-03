import 'package:cryptafri/screens/AddProductScreen.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:cryptafri/screens/InfosScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'onboarding_screen.dart';

class Splash_screen_valider_invest extends StatefulWidget {
  static const routeName = 'splash_invest_validate';
  const Splash_screen_valider_invest({super.key});

  @override
  State<Splash_screen_valider_invest> createState() =>
      _Splash_screen_valider_investState();
}

class _Splash_screen_valider_investState
    extends State<Splash_screen_valider_invest> {
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
      body: SingleChildScrollView(
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
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "POUR LES INVESTISSEMENT VIA OM-MOMO",
                        style: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Poppins',
                          fontSize: 25,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
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
                              backgroundColor:
                                  const Color.fromARGB(255, 221, 93, 2)),
                          onPressed: () async {
                            await firebaseApi().sendInvestNotif();
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
                                const Text(
                                  'ORANGE MONEY',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 221, 166, 2)),
                          onPressed: () async {
                            await firebaseApi().sendInvestNotif();
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
                                const Text(
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
                Divider(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "POUR LES INVESTISSEMENT VIA USDT",
                        style: TextStyle(
                          color: Colors.amber,
                          fontFamily: 'Poppins',
                          fontSize: 25,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "POUR FINALISER VOTRE TRANSACTION,\n VOUS DEVEZ  COPIER UNE DE NOS ADDRESSES ICI PRESENTE ET EFFECTUER LE TRANSFERT D'USDT  \n (les ADDRESSES sont aussi disponibles dans la section INFO)",
                        style: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Par BEP20",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            CopyableTextButton(InfosPage.BEP20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Par ERC20",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            CopyableTextButton(InfosPage.ERC20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Par TRC20",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            CopyableTextButton(InfosPage.TRC20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Par BEP2",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            CopyableTextButton(InfosPage.BEP2),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Par OPBNB",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            CopyableTextButton(InfosPage.OPBNB),
                          ],
                        ),
                      ),
                    ],
                  ),
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
