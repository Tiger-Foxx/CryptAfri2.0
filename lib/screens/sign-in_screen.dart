import 'package:flutter/material.dart';
import 'ForgotScreen.dart';
import 'Splash_screen.dart';
import 'HomeScreen.dart';
import 'sign-up_screen.dart';
import 'services/Authentification.dart';
import 'package:email_validator/email_validator.dart';
import 'models/USER.dart';
import 'main_screen_page.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = 'sign-in';
  static var utilisateur;
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

//################# #######################################fonctions e attentes

//################# #################################fonctions e attentes
class _SignInScreenState extends State<SignInScreen>
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
  var _isObscure = true;
  // Créer un modèle d'utilisateur avec des attributs email et mot de passe
  USER _user = USER();
  Authentification inscripteur = Authentification();
  bool _isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 42, 42, 43),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 135,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/0.jpg'))),
            ),
            // Un texte pour afficher "Welcome back"
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Content de vous revoir chez Cryptafri!",
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
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
              label: const Text("Continuer avec Google"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.white), // pour avoir un bouton blanc
                foregroundColor: MaterialStateProperty.all(
                    Colors.black), // pour avoir du texte noir
              ),
            ),
            // Créer un widget CircularProgressIndicator qui s'affiche si l'état de la connexion est vrai
            if (_isLoading) CircularProgressIndicator(),
            Form(
              // Passer la clé globale au paramètre key
              key: _formKey,
              child: Column(children: [
                // Un champ pour saisir l'email
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: TextStyle(color: Color.fromARGB(137, 245, 244, 244)),
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
                    style: TextStyle(color: Color.fromARGB(137, 241, 239, 239)),
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Entrez votre mot de passe",
                      border: OutlineInputBorder(),
                      // Ajouter un bouton avec une icône pour basculer la visibilité du mot de passe
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Changer l'icône en fonction de la visibilité du mot de passe
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          // Inverser la valeur de la variable booléenne
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    // Utiliser la variable booléenne pour contrôler la propriété obscureText
                    obscureText:
                        _isObscure, // pour masquer ou afficher le mot de passe
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
                      print(value);
                      return null;
                    },
                    // Ajouter une fonction onSaved pour enregistrer la valeur du champ dans le modèle d'utilisateur
                  ),
                ),

                // Un bouton pour se connecter
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        // TODO: ajouter la logique de connexion
                        // Valider et soumettre le formulaire
                        if (_formKey.currentState!.validate()) {
                          // Enregistrer les données dans le modèle d'utilisateur
                          _formKey.currentState!.save();
                          // Envoyer les données à une API externe
                          SignInScreen.utilisateur = await inscripteur.signIn(
                              _user.email!, _user.password);

                          HomeScreen.signIN_UP = 1;
                          var verif = SignInScreen.utilisateur;
                          if (verif != 0) {
                            showSuccessfulDialog();
                            await Future.delayed(const Duration(seconds: 4),
                                () {
                              if (mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreenPage()),
                                );
                              }
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black54,
                                    title: Text(
                                      "OUPS",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white),
                                    ),
                                    content: SizedBox(
                                      height: 195,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Verifiez, l'email, le mot de passe ou votre connexion internet",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.white),
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
                      child: const Text("Se Connecter",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 238, 185,
                                11)), // pour avoir un bouton rouge
                        // les autres paramètres du ButtonStyle
                      )),
                ),
              ]),
            ),

            // Un texte pour proposer de s'inscrire si on n'a pas de compte
            const Text(
              "Vous n'avez pas encore  de compte ?",
              style: TextStyle(
                color: Color.fromARGB(255, 209, 207, 185),
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
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
                child: const Text(" S'inscrire",
                    style: TextStyle(color: Colors.yellow, fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return const Splash_screen(); // votre page de chargement
                      });
                  await Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop(); // fermer la feuille
                  });
                  Navigator.pushNamed(
                    context,
                    ForgotPasswordScreen.routeName,
                  ); // naviguer vers la page d'inscription
                },
                child: const Text(" Mot de passe oublié ?",
                    style: TextStyle(
                        color: Color.fromARGB(255, 170, 153, 3), fontSize: 18)),
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
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
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
                  "Connexion Reussie",
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
