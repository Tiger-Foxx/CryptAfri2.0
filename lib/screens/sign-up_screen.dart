import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'Splash_screen.dart';
import 'sign-in_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'main_screen_page.dart';
import 'package:lottie/lottie.dart';
import 'services/Authentification.dart';
import 'models/USER.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'sign-up';
  static var utilisateur;
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

//################# #######################################fonctions e attentes

//################# #################################fonctions e attentes

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  @override
  void initState() {
    super.initState();

    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  // Créer une clé globale pour le formulaire
  final _formKey = GlobalKey<FormState>();

  // Créer un modèle d'utilisateur avec des attributs email et mot de passe
  USER _user = USER();
  Authentification inscripteur = Authentification();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            //image et message de bienvenue
            Container(
              height: 135,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/0.jpg'))),
            ),

            // Un texte pour afficher "Créez votre compte"
            const Padding(
              padding: EdgeInsets.all(7.0),
              child: Text(
                "Bienvenue sur Cryptafri,Créez votre compte !",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //bouton de connexion google
            ElevatedButton.icon(
              onPressed: () async {
                // Mettre l'état de la connexion à vrai
                setState(() {
                  _isLoading = true;
                });
                // Appeler la fonction signInWithGoogle avec await
                var utilisateur = await inscripteur.GoogleSignUp();
                // Si la connexion réussit, mettre l'état de la connexion à faux
                setState(() {
                  _isLoading = false;
                });
                // Naviguer vers la page d'accueil
                showSuccessfulDialog();
                await Future.delayed(Duration(seconds: 4), () {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreenPage()),
                    );
                  }
                });
              },
              icon: Image.asset(
                'assets/images/google.png',
                width: 26,
              ), // votre image du logo Google
              label: const Text("S'incrire via Google"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.white), // pour avoir un bouton blanc
                foregroundColor: MaterialStateProperty.all(
                    Colors.black), // pour avoir du texte noir
              ),
            ),

            // Créer un widget CircularProgressIndicator qui s'affiche si l'état de la connexion est vrai
            if (_isLoading) CircularProgressIndicator(),
            // Englober tous les champs de texte dans un widget Form
            Form(
              // Passer la clé globale au paramètre key
              key: _formKey,
              child: Column(
                children: [
                  // Un champ pour saisir l'email
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black54),
                      cursorColor: Colors.yellow,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "Entrez votre email",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType
                          .emailAddress, // pour avoir un clavier adapté aux emails
                      // Ajouter un validateur pour le champ email
                      validator: (value) {
                        // Vérifier si le texte est vide
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        // Vérifier si le texte respecte un format d'email
                        if (!EmailValidator.validate(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        // Si tout est ok, renvoyer null
                        _user.email = value;
                        return null;
                      },
                      // Ajouter une fonction onSaved pour enregistrer la valeur du champ dans le modèle d'utilisateur
                    ),
                  ),
                  // Un champ pour saisir le mot de passe
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black54),
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Entrez votre mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // pour masquer le mot de passe
                      // Ajouter un validateur pour le champ mot de passe
                      validator: (value) {
                        // Vérifier si le texte est vide
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        // Vérifier si le texte a une longueur minimale de 6 caractères
                        if (value.length < 6) {
                          return "Veuillez entrer un mot de passe d'au moins 6 caractères";
                        }
                        // Si tout est ok, renvoyer null
                        _user.password = value;
                        return null;
                      },
                      // Ajouter une fonction onSaved pour enregistrer la valeur du champ dans le modèle d'utilisateur
                    ),
                  ),
                  // Un champ pour confirmer le mot de passe
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black54),
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirmez votre mot de passe",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // pour masquer le mot de passe
                      // Ajouter un validateur pour le champ de confirmation
                      validator: (value) {
                        // Vérifier si le texte est vide
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        // Vérifier si le texte correspond au mot de passe saisi précédemment
                        if (value != _user.password) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        // Si tout est ok, renvoyer null
                        return null;
                      },
                    ),
                  ),
                  // Un bouton pour s'inscrire
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          // Valider et soumettre le formulaire
                          if (_formKey.currentState!.validate()) {
                            // Enregistrer les données dans le modèle d'utilisateur
                            _formKey.currentState!.save();
                            // Envoyer les données à une API externe
                            print(_user.email!.toString() +
                                "--" +
                                _user.password);
                            SignUpScreen.utilisateur = await inscripteur.signUp(
                                _user.email!, _user.password);
                            HomeScreen.signIN_UP = 0;
                            var verif = SignUpScreen.utilisateur;
                            if (verif != 0) {
                              showSuccessfulDialog();
                              await Future.delayed(Duration(seconds: 4), () {
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreenPage()),
                                  );
                                }
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "OUPS",
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                      content: SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Verifiez, l'email  n'existe pas  ou votre connexion internet",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                            Center(
                                              child: Lottie.asset(
                                                  "assets/lotties/animation_lkqn0ikf.json",
                                                  animate: true),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }
                        },
                        child: const Text("S'inscrire",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255,
                                    255), // pour avoir du texte blanc
                                fontSize: 16)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 238, 185,
                                  11)), // pour avoir un fond jaune
                          // les autres paramètres du ButtonStyle
                        )),
                  ),

                  // Un texte pour proposer de s'inscrire si on n'a pas de compte
                  const Text("Vous avez deja un compte ? "),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextButton(
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
                      child: const Text(" Se connecter",
                          style: TextStyle(
                              color: Color.fromARGB(255, 214, 193, 5),
                              fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessfulDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Color.fromARGB(120, 255, 196, 0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Lottie.asset("assets/lotties/successfully-done.json",
                  repeat: false,
                  controller: lottieController, onLoaded: (composition) {
                lottieController.duration = composition.duration;
                lottieController.forward();
              }),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Inscription Réussie",
                  style: TextStyle(
                      color: Color.fromARGB(255, 45, 250, 52),
                      fontSize: 21,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 14),
            ]),
          ));
}
