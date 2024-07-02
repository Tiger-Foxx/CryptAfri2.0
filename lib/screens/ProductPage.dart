import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/Splash_screen_info2.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/models/product.model.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  static const routeName = 'product';
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  var fav = false;
  int frais = 0;
  int number = 0;
  String? Reseau;
  String? porteFeuille;
  String? whatsapp;
  String? Nom;
  String? numero;
  String? adressePorteFeuille;
  String? ID;
  int prix = 0;
  void makeFav() {
    setState(() {
      fav = !fav;
    });
  }

  String generateId() {
    Random random = Random();
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

  Future<void> _addAchatToFirestore() async {
    // Créer une référence à la collection 'ventes'
    CollectionReference ventes =
        FirebaseFirestore.instance.collection('achats');
    String id = generateId();

// Créer une référence à un document avec cet identifiant
    DocumentReference vente = ventes.doc(id);

    // Ajouter un document à la collection avec les données du formulaire
    await vente.set({
      'ID': id,
      'prix': prix,
      'adressePorteFeuille': adressePorteFeuille,
      'date': Timestamp.fromDate(DateTime.now()),
      'nom': Nom,
      'porte_feuille': porteFeuille,
      'quantite': number,
      'montant_XAF': (number + frais) * prix,
      'numero_compte': numero,
      'whatsapp': whatsapp,
    });

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Validation en cours, Veuillez effectuer le transfert...'),
        backgroundColor: Colors.green,
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return const Splash_screen_info2(); // votre page de chargement
        });
    await Future.delayed(const Duration(seconds: 55), () {
      Navigator.of(context).pop(); // fermer la feuille
      firebaseApi().sendAchatNotif();
    });
  }

// Obtenir l'email de l'utilisateur courant
  Future<String?> getUserEmail() async {
    var _Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = _Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email;
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    Reseau = product.porteFeuille;
    String chaineImage = product.image;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            floating: true,
            stretch: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(
                    !fav ? Icons.money_off : Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    makeFav();
                  },
                  label: Text("Info Crypto"),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.ID,
                child: chaineImage.contains("http")
                    ? Image.network(
                        chaineImage,
                      )
                    : Image.asset(
                        chaineImage,
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(188, 0, 0, 0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      product.name.toString().toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      " RESEAU : " + product.porteFeuille.toString() + " ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 243, 171, 36),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Prix d'achat : " +
                          product.prix_achat.toString() +
                          " XAF" +
                          "\nPrix de Vente : " +
                          product.prix_vente.toString() +
                          " XAF",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(178, 255, 255, 255),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      number.toString() +
                          " " +
                          product.name +
                          " + " +
                          product.frais.toString() +
                          " (frais) "
                              '\n' +
                          (product.prix_vente * (number + product.frais))
                              .toString() +
                          ' XAF |Total',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      // Utiliser la clé globale pour le formulaire
                      key: _formKey,
                      child: Column(
                        children: [
                          // Créer un champ de texte pour le nombre
                          TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Quantite Voulue',
                              border: OutlineInputBorder(),
                            ),
                            // Valider que le champ contient un nombre entier
                            validator: (value) {
                              if (value!.isEmpty ||
                                  int.tryParse(value) == null) {
                                return 'Veuillez entrer un nombre entier';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                number = int.parse(value!);
                                print(value);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                number = int.parse(value!);
                                porteFeuille = product.porteFeuille;
                                prix = product.prix_vente;
                                frais = product.frais;
                                print(value);
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Créer un champ de texte pour le numéro
                          TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Numero Compte OM|MOMO',
                              border: OutlineInputBorder(),
                            ),
                            // Valider que le champ contient un numéro de téléphone valide
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Veuillez entrer un numéro de Compte valide';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                numero = value;
                                print(value);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                numero = value;
                                print(value);
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Créer un champ de texte pour le nom
                          TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),

                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Votre Nom COMPTE OM|MOMO',
                              border: OutlineInputBorder(),
                            ),
                            // Valider que le champ n'est pas vide
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                Nom = value;
                                print(value);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                Nom = value;
                                print(value);
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Créer un champ de texte pour le numéro
                          TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Numero de Tel',
                              border: OutlineInputBorder(),
                            ),
                            // Valider que le champ contient un numéro de téléphone valide
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Veuillez entrer un numéro de téléphone valide';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                whatsapp = value;
                                print(value);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                whatsapp = value;
                                print(value);
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Créer un champ de texte pour l'adresse du portefeuille
                          TextFormField(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),

                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText:
                                  'Votre Adresse : ' + product.porteFeuille,
                              border: OutlineInputBorder(),
                            ),
                            // Valider que le champ n'est pas vide
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Veuillez entrer l'adresse de votre portefeuille";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                adressePorteFeuille = value;
                                print(value);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                adressePorteFeuille = value;
                                print(value);
                              });
                            },
                          ),

                          SizedBox(height: 16.0),
                          // Créer un bouton pour valider le formulaire
                          Row(
                            children: [
                              SizedBox(width: 40),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _addAchatToFirestore();
                                    }
                                  },
                                  icon: const Icon(Icons.money_off),
                                  label: Text("Valider l'achat"),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Lottie.asset('assets/lotties/buy.json'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(9),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                sendMsg(
                                    "message CryptAfri " +
                                        " pour le produit " +
                                        product.name.toString(),
                                    product.numero.toString());
                                print(product.name);
                                // Appeler la fonct
                                //sendion addToCart avec l'identifiant du produit
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 14, 230, 21),
                                      content: Text(
                                        '${product.name} nous Contacterons le vendeur',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white),
                                      )),
                                );
                              },
                              icon: Image.asset(
                                'assets/images/what.png',
                                height: 30,
                              ),
                              label: Text("Service Client"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void sendMsg(String message, String number) {
    // Encoder le message
    String encodedMessage = Uri.encodeComponent(message);

    // Construire l'URL
    String url = 'https://wa.me/$number?text=$encodedMessage';

    // Lancer l'URL
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
