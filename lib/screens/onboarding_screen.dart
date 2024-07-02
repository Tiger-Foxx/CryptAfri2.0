import 'package:flutter/material.dart';
import 'sign-in_screen.dart';
import 'sign-up_screen.dart';
import 'splash_screen.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = 'Onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _PageController;
  int _curentPage = 0;
  final int _totalPages = 4;
  final Titre = [
    "LA CRYPTO A PORTEE DE CLICK ",
    "VOUS NEGOCIEZ !",
    "VOUS GAGNEZ !",
    "RECHARCHEZ AUSSI\nFACILEMENT!",
  ];
  final SousTitre = [
    "Découvrez l'application qui va tout changer !",
    "Sur Cryptafri Votre Liberté est TOTALE  !",
    "C'est avant tout l'avantage que notre marché confère !",
    "Pour ,les Parieurs Rechargez facilement vos Comptes de paris"
  ];
  final images = [
    "assets/images/0.jpg",
    "assets/lotties/negocier.json",
    "assets/lotties/economiser.json",
    "assets/lotties/football.json",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _PageController = PageController();

    _PageController.addListener(() {
      setState(() {
        _curentPage = _PageController.page!.round();
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _PageController,
              children: List.generate(
                  _totalPages,
                  (index) => Container(
                        color: Colors.black87,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 250,
                                width: double.infinity,
                                child: index == 0
                                    ? Image.asset(
                                        images[index],
                                        fit: BoxFit.contain,
                                      )
                                    : Lottie.asset(
                                        images[index],
                                        fit: BoxFit.contain,
                                        animate: true,
                                      ),
                              ),
                              Text(Titre[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Poppins',
                                      color: Color.fromARGB(255, 255, 196, 2))),
                              Text(SousTitre[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    color: Colors.white,
                                  )),
                            ]),
                      )),
            ),
          ),
          Page_indicators(currentPage: _curentPage, totalPage: _totalPages),
          const AuthenticationButtons(),
        ],
      ),
    ));
  }
}

//########################## ZONE 1 ###############################
class AuthenticationButtons extends StatelessWidget {
  const AuthenticationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      height: 150,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return const Splash_screen(); // votre page de chargement
                  });
              await Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pop(); // fermer la feuille
              });
              Navigator.pushNamed(
                context,
                SignInScreen.routeName,
              ); // naviguer vers la page d'inscription
            },
            child: const Text('Sign-In',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 236, 194, 5))),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 70),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () async {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return const Splash_screen(); // votre page de chargement
                  });
              await Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pop(); // fermer la feuille
              });
              Navigator.pushNamed(
                context,
                SignUpScreen.routeName,
              ); // naviguer vers la page d'inscription
            },
            child: const Text('Sign-Up',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 70),
                backgroundColor: const Color.fromARGB(255, 236, 194, 5)),
          ),
        ],
      ),
    );
  }
}

//########################## ZONE 1 ###############################

class Page_indicators extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  const Page_indicators(
      {super.key, required this.currentPage, required this.totalPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < totalPage; i++)
            Container(
              width: i == currentPage ? 50 : 15,
              height: 15,
              decoration: BoxDecoration(
                color: i == currentPage ? Colors.yellow : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(7),
            ),
        ],
      ),
    );
  }
}
