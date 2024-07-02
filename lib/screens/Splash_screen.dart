import 'package:cryptafri/screens/main_screen_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'onboarding_screen.dart';

class Splash_screen extends StatefulWidget {
  static const routeName = 'splash';
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
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
                height: 100.0,
              ),
              Lottie.asset('assets/lotties/bitcoin1.json'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "CRYPTAFRI ... ",
                  style:
                      TextStyle(color: Colors.white54, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          (_auth.currentUser == null ? OnboardingScreen() : MainScreenPage()),
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
