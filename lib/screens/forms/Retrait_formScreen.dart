// Importer les packages nécessaires
// ignore_for_file: unused_field, prefer_final_fields, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_info.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_retrait.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_valider_retrait.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../home/HomeScreen.dart';
import '../Splash_screen.dart';
import '../main_screen_page.dart';
import 'package:lottie/lottie.dart';

// Définir la classe AddProductScreen qui hérite de StatefulWidget
class RetraitFormScreen extends StatefulWidget {
  static const routeName = 'retrait';

  // Créer le constructeur de la classe avec une clé optionnelle
  const RetraitFormScreen({Key? key, double? this.solde}) : super(key: key);
  final double? solde;

  // Créer la méthode createState qui retourne une instance de _AddProductScreenState
  @override
  _RetraitFormScreenState createState() => _RetraitFormScreenState();
}

// Définir la classe _AddProductScreenState qui hérite de State<AddProductScreen>
class _RetraitFormScreenState extends State<RetraitFormScreen>
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

  Random random = Random();

  String generateId() {
    // Créer une variable pour stocker l'identifiant
    String id = '';

    // Créer une liste de caractères possibles
    List<String> chars = 'abcdefghijklmnopqrstuvwxyz0123456789'.split('');

    // Générer 8 caractères aléatoires et les ajouter à l'identifiant
    for (int i = 0; i < 8; i++) {
      id += chars[random.nextInt(chars.length)];
    }

    // Retourner l'identifiant
    return id;
  }

// Obtenir l'email de l'utilisateur courant
  String? getUserEmail() {
    // ignore: no_leading_underscores_for_local_identifiers
    var _Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = _Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email.toString();
  }

  // Créer une clé globale pour le widget Form
  final _formKey = GlobalKey<FormState>();

  // Créer des variables pour stocker les valeurs des champs du formulaire
  double MontantMax = 0.0;
  String? _numero;
  String? _nomCompte;
  int? _montant = 0;
  String? _whatsapp;

  // Créer une variarle booléenne pour indiquer si le vendeur est l'utilisateur courant ou non
  bool _isCurrentUser = false;

  // Créer une méthode pour ajouter le produit à la collection Firestore
  Future<void> _addRetraitToFirestore() async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');
    String id = "retrait de " + getUserEmail()! + generateId();

    await transactions.doc(id).set({
      'NumOM_MOMO': _numero,
      'date': Timestamp.fromDate(DateTime.now()),
      'emailUtilisateur': getUserEmail(),
      'montant': _montant,
      'nomCompte': _nomCompte,
      'type': 'retrait',
      'whatsapp': _whatsapp,
      'valide': false,
    });
    //showSuccessfulDialog();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retrait enregistré avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return const Splash_screen_valider_retrait(); // votre page de chargement
        });
    await Future.delayed(const Duration(seconds: 500), () {
      Navigator.pushNamed(context, 'mainClient'); // fermer la feuille
    });
  }

  late Map<String, dynamic> arguments;
  late String solde;

  // Créer la méthode build qui retourne le widget Scaffold
  @override
  Widget build(BuildContext context) {
    MontantMax = widget.solde ?? 0.0;
    // Retourner le widget Scaffold avec une appbar et un body
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: const Icon(Icons.sell),
        title: const Text(
          'EFFECTUER UN RETRAIT',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Whatsapp',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre numero whatsapp';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _whatsapp = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Montant que vous voulez Retirer en XAF',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le Montant';
                    }
                    if (int.parse(value) > MontantMax) {
                      return 'Vous ne pouvez retirer que ${widget.solde!.toStringAsFixed(2)} XAF Maximum!';
                    }
                    if (int.parse(value) < 100) {
                      return 'Vous ne pouvez pas retirer moins de 100 XAF !';
                    }
                    try {
                      int.parse(value);
                      return null;
                    } catch (e) {
                      return 'Veuillez entrer un nombre entier valide';
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      _montant = int.parse(value!);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _montant = int.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  "$_montant XAF = ${_montant! / 650} USDT ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 255, 1, 1)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'numéro OM/MOMO',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre numero de Compte OM-MOMO';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _numero = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom_Compte OM/MOMO',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom de Compte';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _nomCompte = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    /// il faudra afficher un message de confirmation
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      await _addRetraitToFirestore();
                    }
                  },
                  child: const Text('CONFIRMER LE RETRAIT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }

  void showSuccessfulDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.white,
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
                  "Validation en cours",
                  style: TextStyle(
                      color: Color.fromARGB(255, 45, 250, 52),
                      fontSize: 21,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 14),
            ]),
          ));

  void sendMsg(String message, String number) {
    // Encoder le message
    String encodedMessage = Uri.encodeComponent(message);

    // Construire l'URL
    String url = 'https://wa.me/$number?text=$encodedMessage';

    // Lancer l'URL
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {}
  }
}
