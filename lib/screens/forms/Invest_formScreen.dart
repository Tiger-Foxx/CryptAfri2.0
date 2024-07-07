// Importer les packages nécessaires
// ignore_for_file: unused_field, prefer_final_fields, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_info.dart';
import 'package:cryptafri/screens/Splash/Splash_screen_validerInvest.dart';
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
class InvestFormScreen extends StatefulWidget {
  static const routeName = 'investir';

  // Créer le constructeur de la classe avec une clé optionnelle
  const InvestFormScreen({Key? key}) : super(key: key);

  // Créer la méthode createState qui retourne une instance de _AddProductScreenState
  @override
  _InvestFormScreenState createState() => _InvestFormScreenState();
}

// Définir la classe _AddProductScreenState qui hérite de State<AddProductScreen>
class _InvestFormScreenState extends State<InvestFormScreen>
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
  int MontantMin = 10000;
  String? _numero = "";
  String? _nomCompte = "";
  int? _montant = 0;
  String? _whatsapp;
  String? _portefeuille = "";

  // Créer une variarle booléenne pour indiquer si le vendeur est l'utilisateur courant ou non
  bool _isCurrentUser = false;

  // Créer une méthode pour ajouter le produit à la collection Firestore
  Future<void> _addInvestissementToFirestore() async {
    CollectionReference transactions =
        FirebaseFirestore.instance.collection('transactions');
    String id = "investissement de " + getUserEmail()! + generateId();

    await transactions.doc(id).set({
      'NumOM_MOMO': _numero,
      'AddressePorteFeuille': _portefeuille,
      'date': Timestamp.fromDate(DateTime.now()),
      'emailUtilisateur': getUserEmail(),
      'montant': _montant,
      'nomCompte': _nomCompte,
      'type': 'investissement',
      'valide': false,
      'whatsapp': _whatsapp,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Investissement enregistré avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return Splash_screen_valider_invest(
            montant: _montant.toString(),
          ); // votre page de chargement
        });
    await Future.delayed(const Duration(seconds: 50), () {
      Navigator.pushNamed(context, 'main'); // fermer la feuille
    });
  }

  // Créer la méthode build qui retourne le widget Scaffold
  @override
  Widget build(BuildContext context) {
    // Retourner le widget Scaffold avec une appbar et un body
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: const Icon(Icons.sell),
        title: const Text(
          'EFFECTUER UN IVESTISSEMENT',
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
                    labelText: 'Montant que vous voulez investir en XAF',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le Montant';
                    }
                    if (int.parse(value) < MontantMin) {
                      return 'Vous ne pouvez pas investir moins de ${MontantMin} XAF !';
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
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "SI VOUS PAYEZ EN XAF",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'le num de Compte OM-MOMO qui fera le transfert',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'le de Compte OM-MOMO qui fera le transfert';
                    // }
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
                    labelText: 'Le nom de compte OM-MOMO qui fera le transfert',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'Le nom de compte OM-MOMO qui fera le transfert';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _nomCompte = value;
                    });
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "SI VOUS PAYEZ EN UDST",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'VOTRE ADDRESSE DE PORTEFEUILLE USDT',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'Le nom de compte OM-MOMO qui fera le transfert';
                    // }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _portefeuille = value;
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

                      await _addInvestissementToFirestore();
                    }
                  },
                  child: const Text('CONFIRMER L\'INVESTISSEMENT'),
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
