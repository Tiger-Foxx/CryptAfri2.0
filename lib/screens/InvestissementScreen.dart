// ignore_for_file: unnecessary_import

// import 'package:cryptafri/screens/InfosScreen.dart';
// import 'package:cryptafri/screens/RetraitScreen.dart';
// import 'package:cryptafri/screens/Splash_screen_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/Splash_screen_retrait.dart';
import 'package:cryptafri/screens/models/transaction.model.dart';
import 'package:cryptafri/screens/services/fonctions.utiles.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:cryptafri/screens/SellsScreen.dart';
// import 'package:cryptafri/screens/sign-in_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvestissementScreen extends StatefulWidget {
  const InvestissementScreen({super.key});
  static const routeName = 'Investissement';

  @override
  State<InvestissementScreen> createState() => _InvestissementScreenState();
}

class _InvestissementScreenState extends State<InvestissementScreen> {
  TransactionModel?
      _latestTransaction; // Variable pour stocker la dernière transaction de l'utilisateur

  final List<bool> _termsChecked = [false, false, false];
  bool _loading = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    _fetchLatestTransaction(); // Récupérer la dernière transaction au démarrage
  }

  Future<void> _fetchLatestTransaction() async {
    try {
      String email = getUserEmail()!;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('emailUtilisateur', isEqualTo: email)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _latestTransaction =
              TransactionModel.fromFirestore(snapshot.docs.first);
          _loading = false;
        });
      } else {
        setState(() {
          _latestTransaction = null; // Aucun résultat trouvé
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement des transactions: $e';
        _loading = false;
      });
      print('Erreur de chargement des transactions: $e');
    }
  }

  void _onCheckboxChanged(int index, bool value) {
    setState(() {
      _termsChecked[index] = value;
    });
  }

  bool get _isAllTermsChecked => _termsChecked.every((term) => term);

  // ignore: unused_element
  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(58, 255, 193, 7),
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Menu d\'investissement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: _HeroWidget(),
                ),
                const SizedBox(height: 10),
                _ExplanationText(onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                }),
                const Divider(),
                const SizedBox(height: 5),
                _InvestButton(onPressed: () {
                  _showModalBottomSheet(context);
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 900,
                    height: 125,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 216, 163, 3),
                            Colors.amber,
                            Colors.yellow
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: Colors.black87,
                        width: 2,
                      ),
                      color: Colors.amber,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _latestTransaction != null
                          ? Column(
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  "DERNIERE TRANSACTION",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Colors.white70),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  _latestTransaction!.type.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color:
                                          _latestTransaction!.type == 'retrait'
                                              ? Colors.red
                                              : Colors.blue),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  "${_latestTransaction!.montant} XAF",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: Colors.black),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  _latestTransaction!.valide
                                      ? "Valide"
                                      : "Non validé",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                      color: _latestTransaction!.valide
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Center(child: CircularProgressIndicator()),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Votre derniere transaction s'affichera ici "),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
        backgroundColor: const Color.fromARGB(255, 235, 158, 3),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.zero),
                color: Colors.amber,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage('assets/images/0.jpg'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Contrat d\'Investissement dans la Plateforme Cryptafri\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ce contrat d\'investissement régit l\'utilisation des fonds investis sur la plateforme Cryptafri. Avant de procéder à votre investissement, veuillez lire attentivement et comprendre les termes et conditions énoncés ci-dessous. En investissant sur notre plateforme, vous acceptez d\'être lié par les présentes politiques et règles.\n\n'
                    '1. Objectif de l\'investissement :\n'
                    'L\'investissement dans la plateforme Cryptafri n\'implique pas l\'acquisition de parts ou d\'actions de la société Cryptafri. L\'objectif de cet investissement est de générer des revenus récurrents pour les investisseurs grâce aux différentes activités menées par l\'équipe Cryptafri.\n\n'
                    '2. Modalités d\'investissement :\n'
                    'a. Souscription des fonds : En tant qu\'investisseur, vous pouvez placer des fonds sur la plateforme Cryptafri conformément aux modalités spécifiées dans le processus d\'investissement. Le montant minimum d\'investissement et les conditions de paiement seront clairement définis dans le processus de souscription.\n\n'
                    'b. Rendement de l\'investissement : Les investisseurs recevront un intérêt de 4% sur leurs fonds investis, versé de manière hebdomadaire. Ce rendement est garanti par Cryptafri et ne dépend pas des performances de la plateforme.\n\n'
                    'c. Retrait des fonds : Les fonds investis ne sont retirables qu\'après une période de 3 mois à compter de la date d\'investissement. seuls les intérêts pourrons être retirable pendant les 3 premiers mois. Passé ce délai, les investisseurs peuvent retirer leurs fonds investi à tout moment.\n\n'
                    'Exemple de distribution des revenus en XAF :\n'
                    '- Montant investi : 1 00 000 XAF\n'
                    '- Intérêt hebdomadaire (4%) : 4000 XAF\n'
                    '- Intérêt versé par semaine (retirable): 4000 XAF\n\n'
                    '3. Responsabilité de Cryptafri :\n'
                    'a. Gestion des fonds : Cryptafri s\'engage à gérer les fonds des investisseurs avec le plus grand soin et à les utiliser conformément à l\'objectif de générer des revenus récurrents. Nous nous efforcerons d\'assurer une gestion diligente et responsable des fonds investis.\n\n'
                    'b. Clause de non-responsabilité : Cryptafri ne peut pas garantir à 100% que les rendements prévus seront atteints. La valeur des fonds investis peut être affectée par divers facteurs, y compris les conditions du marché et d\'autres circonstances économiques. Vous comprenez et acceptez que l\'investissement comporte des risques inhérents et que vous êtes seul responsable de vos décisions d\'investissement.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.black87,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Termes et conditions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const Divider(),
                            CheckboxListTile(
                              title: Text(
                                'Terme ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              value: _termsChecked[index],
                              onChanged: (value) {
                                setModalState(() {
                                  _onCheckboxChanged(index, value!);
                                });
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          _isAllTermsChecked
                              ? const Color.fromARGB(255, 235, 158, 3)
                              : Colors.grey,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: _isAllTermsChecked
                          ? () => Navigator.pushNamed(context, 'splash_invest')
                          : null,
                      label: const Text(
                        'Accepter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ExplanationText extends StatelessWidget {
  final VoidCallback onPressed;

  const _ExplanationText({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "Bienvenue dans la section investissement de CryptAfri, nous vous invitons avant toute chose à lire attentivement notre contrat d'investissement.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(156, 235, 3, 3),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: const Text(
              'CONTRAT D\'INVESTISSEMENT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _InvestButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.amber,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      child: const Text(
        'INVESTIR',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );
  }
}

class _HeroWidget extends StatefulWidget {
  // ignore: unused_element
  const _HeroWidget({super.key});

  @override
  State<_HeroWidget> createState() => __HeroWidgetState();
}

class __HeroWidgetState extends State<_HeroWidget> {
  final _infos = [
    {
      'code': 'VOTRE SOLDE EST ICI',
      'title': '25000 XAF',
      'image': 'assets/images/kiss2.jpg',
    },
    {
      'code': 'VOTRE SOLDE EST ICI',
      'title': '14 USDT',
      'image': 'assets/images/kiss1.png',
    },
    {
      'code': 'CrytpAfri',
      'title': 'INVESTISSEZ !',
      'image': 'assets/images/kiss3.jpg',
    },
  ];
  int _currentInfo = 0;
  // ignore: non_constant_identifier_names
  final _PageControler = PageController();

  @override
  void initState() {
    super.initState();
    _PageControler.addListener(() {
      setState(() => _currentInfo = _PageControler.page!.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          )
        ],
        gradient: const LinearGradient(
            colors: [Colors.black, Colors.amber, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(21),
        color: Colors.amber,
      ),
      child: Stack(
        children: [
          PageView(
            controller: _PageControler,
            children: _infos.map((info) => _buildInfo(info)).toList(),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(bottom: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _infos.map((info) => _buildPagination(info)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(Map<String, String> info) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: _infos.indexOf(info) == _currentInfo ? 50 : 20,
      height: 10,
      decoration: BoxDecoration(
          color: _infos.indexOf(info) == _currentInfo
              ? const Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(197, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildInfo(Map<String, String> info) {
    return Stack(children: [
      Positioned(
        top: 29,
        left: 29,
        child: Text(
          _infos[_currentInfo]['code']!.toUpperCase(),
          style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.702),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Positioned(
        top: 80,
        left: 29,
        child: Text(
          _infos[_currentInfo]['title']!.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Positioned(
        top: 125,
        left: 29,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Splash_screen_retrait.routeName,
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: const Color.fromARGB(255, 253, 207, 3),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Row(
            children: [
              Text('EFFECTUER UN RETRAIT'),
              Icon(Icons.card_giftcard),
            ],
          ),
        ),
      ),
    ]);
  }
}
