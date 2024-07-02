// Importer les packages nécessaires
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/Splash_screen_info.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'HomeScreen.dart';
import 'Splash_screen.dart';
import 'main_screen_page.dart';
import 'package:lottie/lottie.dart';

// Définir la classe AddProductScreen qui hérite de StatefulWidget
class RetraitScreen extends StatefulWidget {
  static const routeName = 'retrait';
  static String portef = '0x5096ffdf9c2f6f26fec795b85770452e100cad50';
  static String portefName = 'TRC 20';
  // Créer le constructeur de la classe avec une clé optionnelle
  const RetraitScreen({Key? key}) : super(key: key);

  // Créer la méthode createState qui retourne une instance de _AddProductScreenState
  @override
  _RetraitScreenState createState() => _RetraitScreenState();
}

// Définir la classe _AddProductScreenState qui hérite de State<AddProductScreen>
class _RetraitScreenState extends State<RetraitScreen>
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
// Cette fonction prend une liste de maps et un critère de clé
// Elle retourne une liste de maps qui ne contient que des éléments uniques selon la valeur de la clé
  List<Map<String, dynamic>> filterUnique(
      List<Map<String, dynamic>> list, String key) {
    // On crée un set vide pour stocker les valeurs uniques
    Set<dynamic> uniqueValues = {};
    // On crée une liste vide pour stocker les maps filtrés
    List<Map<String, dynamic>> filteredList = [];
    // On parcourt la liste de maps
    for (Map<String, dynamic> map in list) {
      // On récupère la valeur de la clé pour le map courant
      dynamic value = map[key];
      // On vérifie si la valeur est déjà dans le set
      if (!uniqueValues.contains(value)) {
        // Si non, on ajoute la valeur au set
        uniqueValues.add(value);
        // On ajoute le map à la liste filtrée
        filteredList.add(map);
      }
    }
    // On retourne la liste filtrée
    return filteredList;
  }

// Créer une référence à la collection Firestore
  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('produits');
  // Créer une fonction pour récupérer les documents de la collection Firestore
  int counter = 0;
  int counter2 = 0;
  var Maxs;
  var prixAchats;

  Future<List<Map<String, dynamic>>> getCategories() async {
    // Obtenir les documents de la collection Firestore
    QuerySnapshot querySnapshot = await categoriesRef.get();
    // Convertir les documents en une liste de Map<String, dynamic>
    List<Map<String, dynamic>> categories = querySnapshot.docs
        .map((doc) => {
              'id': doc['ID'],
              'name': doc['name'],
              'min_vente': doc['min_vente'],
              'icon': Icons.money,
            })
        .toList();
    categories = filterUnique(categories, 'name');
    Maxs = querySnapshot.docs
        .map((doc) => {
              doc['name'].toString(): int.parse(doc['min_vente'].toString()),
              'cle': doc['name'].toString(),
            })
        .toList();
    Maxs = filterUnique(Maxs, 'cle');
    prixAchats = querySnapshot.docs
        .map((doc) => {
              doc['name'].toString(): int.parse(doc['prix_achat'].toString()),
              'cle': doc['name'].toString(),
            })
        .toList();
    prixAchats = filterUnique(prixAchats, 'cle');
    print("Maxs " + Maxs.toString());
    print("Achats " + prixAchats.toString());
    print("Categories " + categories.toString());
    // Retourner la liste de Map<String, dynamic>
    return categories;
  }

  String getValue(String? param, List<Map<String?, dynamic>> liste) {
    bool ok = false;
    for (var i = 0; i < liste.length; i++) {
      print("\n\n\n\n l'element est '" +
          liste[i][param].toString() +
          "' et le parametre est :  '" +
          param.toString() +
          "'" +
          liste.length.toString());
      if (liste[i]['cle'].toString() == param) {
        print('je contient ');
        ok = true;
        return liste[i][param].toString();
      }
    }
    return "0";
  }

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
    var _Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = _Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email.toString();
  }

  // Créer une clé globale pour le widget Form
  final _formKey = GlobalKey<FormState>();

  // Créer des variables pour stocker les valeurs des champs du formulaire
  int prix_choix = 70;
  String? _category = "TRX";
  String? _portefeuille = "TRC 20";
  String? _description;
  String? _emailVendeur;
  String? _image;
  String? _name;
  int? _price;
  int _quantity = 0;
  String? _numero;
  String? _whatsapp;

  // Créer une variarle booléenne pour indiquer si le vendeur est l'utilisateur courant ou non
  bool _isCurrentUser = false;

  // Créer une méthode pour ajouter le produit à la collection Firestore
  Future<void> _addVenteToFirestore(String? portefeuille) async {
    // Créer une référence à la collection 'ventes'
    CollectionReference ventes =
        FirebaseFirestore.instance.collection('ventes');
    String id = generateId();

    // Créer une référence à un document avec cet identifiant
    DocumentReference vente = ventes.doc(id);

    // Ajouter un document à la collection avec les données du formulaire
    await vente.set({
      'ID': id,
      'category': _category,
      'date': Timestamp.fromDate(DateTime.now()),
      'name': _name,
      'porteFeuille': _portefeuille,
      'prix_unitaire': int.parse(getValue(_category, prixAchats)),
      'quantity': _quantity,
      'montant_XAF': _price! * _quantity,
      'numero_compte': _numero,
      'whatsapp': _whatsapp,
    });

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Validation en cours, veuillez effectuer le transfert'),
        backgroundColor: Colors.green,
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return const Splash_screen_info(); // votre page de chargement
        });
    await Future.delayed(const Duration(seconds: 55), () {
      Navigator.of(context).pop(); // fermer la feuille
    });
  }

  List<Map<String, dynamic>> porteFeuilles = [
    {
      'id': 0,
      'name': 'ERC 20',
      'lien': '0x5096ffdf9c2f6f26fec795b85770452e100cad50'
    },
    {
      'id': 1,
      'name': 'TRC 20',
      'lien': 'TWNBb1W76TwQ1HXwFir3SxD5D9sE3d64Lu',
    },
    {
      'id': 2,
      'name': 'BEP 20',
      'lien': '0x5096ffdf9c2f6f26fec795b85770452e100cad50'
    },
  ];

  String getLinkPorteFeuille(String param) {
    for (var porte in porteFeuilles) {
      if (porte['name'] == param) {
        return porte['lien'];
      }
    }
    return 'none';
  }

  // Créer la méthode build qui retourne le widget Scaffold
  @override
  Widget build(BuildContext context) {
    // Retourner le widget Scaffold avec une appbar et un body
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // La Future<List> est résolue, on peut créer le widget DropdownButtonFormField avec la liste de Map<String, dynamic>)
            //

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.amber,
                leading: Icon(Icons.sell),
                title: Text('Vendre sa Crypto'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8.0),
                        TextFormField(
                          decoration: InputDecoration(
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
                              print(value);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Crypto',
                            border: OutlineInputBorder(),
                          ),
                          value: _category,
                          items: snapshot.data!
                              .map((category) => DropdownMenuItem<String>(
                                    value: category['name'],
                                    child: Row(
                                      children: [
                                        Text(category['name']),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _category = value.toString();
                              prix_choix =
                                  int.parse(getValue(_category, prixAchats));
                              _price =
                                  int.parse(getValue(_category, prixAchats));
                              print("\n\n la valeur cathegorie est : " +
                                  getValue(_category, Maxs));
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez choisir la monaie que vous vendez';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Quantité a vendre',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer la quantité';
                            }
                            if (int.parse(value) <
                                int.parse(getValue(_category, Maxs))) {
                              return 'Le minimum que nous achetons est : ' +
                                  getValue(_category, Maxs);
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
                              _quantity = int.parse(value!);
                              prix_choix =
                                  int.parse(getValue(_category, prixAchats));
                              _price =
                                  int.parse(getValue(_category, prixAchats));
                              print(value);
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _quantity = int.parse(value!);
                              print(value);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          _quantity.toString() +
                              " " +
                              _category.toString() +
                              " = " +
                              (_quantity * prix_choix).toString() +
                              " XAF | prix unitaire : " +
                              prix_choix.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.amber),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'numéro OM/MOMO',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre numero de Compte';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _numero = value;
                              print(value);
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom_Compte OM/MOMO',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nom';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _name = value;
                              print(value);
                            });
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText:
                                'PorteFeuille vers lequel vous transferez',
                            border: OutlineInputBorder(),
                          ),
                          value: _portefeuille,
                          items: porteFeuilles
                              .map((porteFeuille) => DropdownMenuItem<String>(
                                    value: porteFeuille['name'],
                                    child: Row(
                                      children: [
                                        Text(
                                          porteFeuille['name'],
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _portefeuille = value.toString();
                              RetraitScreen.portef =
                                  getLinkPorteFeuille(value.toString());
                              RetraitScreen.portefName = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez choisir le porteFeuille';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            /// il faudra afficher un message de confirmation
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              RetraitScreen.portef =
                                  getLinkPorteFeuille(_portefeuille.toString());
                              RetraitScreen.portefName =
                                  _portefeuille.toString();
                              await _addVenteToFirestore(_portefeuille);
                            }
                          },
                          child: Text('Initier la Vente'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  void showSuccessfulDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Lottie.asset("assets/lotties/vendu.json",
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
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
