import 'package:cryptafri/screens/InfosScreen.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:cryptafri/screens/services/fonctions.utiles.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/services/products.services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../forms/ProductPage.dart';
import 'package:search_page/search_page.dart';
import '../Auth/sign-in_screen.dart';
import '../models/product.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import '../Auth/sign-up_screen.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = 'home';
  static int signIN_UP = 0;
  static String mail = "";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  int _currentIndex = 0;
  Widget build(BuildContext context) {
    if (HomeScreen.signIN_UP == 1) {
      HomeScreen.mail = SignInScreen.utilisateur.email!.toString();
    }
    if (HomeScreen.signIN_UP == 0) {
      try {
        HomeScreen.mail = "New " + SignUpScreen.utilisateur.email!.toString();
      } catch (e) {
        HomeScreen.mail = "via google";
      }
    }
    // Accéder au modèle et à la catégorie actuelle

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.amber,

            leading: null,
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 30,
              child: Text(
                "Attention !!!Nous ne sommes pas responsables des ordres hors de la plateforme",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900),
                overflow: TextOverflow.visible,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            floating: true, // faire flotter la barre d'application
            snap: true, // faire enclencher la barre d'application
          ),
        ];
      },
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const Padding(
            padding: EdgeInsets.all(6.0),
            child: _HeroWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 180, 4),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (getUserEmail() == InfosPage.email)
                      ? "BIENVENUE SUR VOTRE CRYPTAFRI CHER ADMINISTRATEUR"
                      : "CHOISISSEZ LA CRYPTO QUE VOUS VOULEZ ACHETER EN FONCTION DU RESEAU D'EMISSION\n (BEP|ERC|TRC)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductsByNetWork(
              parameter: 'BEP 20',
              // passer la catégorie au widget BestSellingProducts
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductsByNetWork(
              parameter: 'BEP 2',
              // passer la catégorie au widget BestSellingProducts
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductsByNetWork(
              parameter: 'ERC 20',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductsByNetWork(
              parameter: 'OPBNB',
              // passer la catégorie au widget BestSellingProducts
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductsByNetWork(
              parameter: 'TRC 20',
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroWidget extends StatefulWidget {
  const _HeroWidget({super.key});

  @override
  State<_HeroWidget> createState() => __HeroWidgetState();
}

class __HeroWidgetState extends State<_HeroWidget> {
  final _infos = [
    {
      'code': 'CrytpAfri',
      'title': 'Confiance',
      'image': 'assets/images/kiss2.jpg',
    },
    {
      'code': 'CrytpAfri',
      'title': 'Bons Prix',
      'image': 'assets/images/kiss1.png',
    },
    {
      'code': 'CrytpAfri',
      'title': 'Satisfaction',
      'image': 'assets/images/kiss3.jpg',
    },
  ];
  int _currentInfo = 0;
  final _PageControler = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _PageControler.addListener(() {
      setState(() => _currentInfo = _PageControler.page!.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    // After 2 seconds, animate to the third page.
    /* Timer(Duration(seconds: 5), () async {
      if (_PageControler.page == _infos.length - 1) {
        _PageControler.animateToPage(0,
            duration: Duration(milliseconds: 1000), curve: Curves.linear);
      } else {
        Future.delayed(Duration(seconds: 1));
        _PageControler.nextPage(
            duration: Duration(milliseconds: 1000), curve: Curves.linear);
      }
    });*/
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 203, 3),
        image: DecorationImage(
            image: ResizeImage(AssetImage(_infos[_currentInfo]['image']!),
                width: 70000),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(21),
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
      margin: EdgeInsets.all(2),
      width: _infos.indexOf(info) == _currentInfo ? 50 : 20,
      height: 10,
      decoration: BoxDecoration(
          color: _infos.indexOf(info) == _currentInfo
              ? Color.fromARGB(255, 255, 255, 255)
              : Color.fromARGB(197, 255, 255, 255),
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
          onPressed: () async {
            var message =
                'MESSAGE CRYPTAFRI ! \nASSISTANCE CLIENT\n\n\n\n Bonjour je suis : ';
            var number = InfosPage.whatsapp;
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
            //ajouterPourcentageTousComptes(10);
          },
          child: Row(
            children: [
              Text('Service Client'),
              Icon(Icons.call),
            ],
          ),
          style: ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor: Color.fromARGB(255, 253, 207, 3),
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    ]);
  }
}

class ProductsByNetWork extends StatefulWidget {
  final parameter;
  const ProductsByNetWork({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  @override
  State<ProductsByNetWork> createState() => _ProductsByNetWorkState(parameter);
}

class _ProductsByNetWorkState extends State<ProductsByNetWork> {
// Une liste de produits fictifs
  var parameter;
  List<Map<String, dynamic>> produits = [];
  _ProductsByNetWorkState(var param) {
    parameter = param;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parameter == 'ERC 20'
                    ? "PAR RESEAU ERC 20 "
                    : (parameter == 'BEP 20'
                        ? "PAR RESEAU BEP 20"
                        : (parameter == 'TRC 20'
                            ? "PAR RESEAU TRC 20"
                            : (parameter == "BEP 2"
                                ? "PAR RESEAU BEP 2"
                                : (parameter == 'OPBNB'
                                    ? "PAR RESEAU BEP OPBNB"
                                    : "Autres")))),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              TextButton(
                child: const Text(
                  "CHOISIR",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color.fromARGB(166, 32, 32, 32),
                  ),
                ),
                onPressed: () {
                  FirebaseApi().sendAchatNotif(); //FONCTION QUE J'AI AJOUTE
                },
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: double.infinity,
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('produits')
                      .where('porteFeuille',
                          isEqualTo:
                              parameter) // si oui, utiliser un filtre sur la requête firebase pour récupérer les produits de la catégorie correspondante
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      var a = snapshot.data!;
                      print(a.docs[0]['name']);
                      if (snapshot.hasData && snapshot.data!.docs[0] != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: CardExample(
                                produit: snapshot.data!.docs[index],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Lottie.asset('assets/lotties/bitcoin2.json'),
                              Text('Une erreur est survenue'),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            const Text('Rien pour ce reseau pour le moment...'),
                            Lottie.asset('assets/lotties/bitcoin2.json'),
                          ],
                        );
                      }
                    } catch (e) {
                      return Column(
                        children: [
                          const Text('Rien pour ce reseau pour le moment...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 18)),
                          SizedBox(
                            height: 100,
                            child: Lottie.asset('assets/lotties/bitcoin2.json',
                                fit: BoxFit.contain),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

class CardExample extends StatelessWidget {
  var produit;

  CardExample({super.key, required this.produit});

  @override
  Widget build(BuildContext context) {
    ProductModel productModel = ProductModel(
      frais: produit['frais'] + 0.0,
      Category: produit['category'],
      numero: produit['numero'],
      ID: produit['ID'],
      date: produit['date'],
      image: produit['image'],
      prix_achat: produit['prix_achat'] + 0.0,
      name: produit['name'],
      quantity: produit['quantity'] + 0.0,
      prix_vente: produit['prix_vente'] + 0.0,
      porteFeuille: produit['porteFeuille'],
      min_vente: produit['min_vente'],
    );
    String chaineImage = produit['image'];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductPage.routeName,
              arguments: productModel,
            );
          },
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: chaineImage.contains("http")
                      ? Image.network(
                          chaineImage,
                        )
                      : Image.asset(
                          chaineImage,
                        ),
                  title: Text(
                    produit['name'],
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  subtitle: Column(
                    children: [
                      Text("Prix d'achat': " +
                          produit['prix_achat'].toString() +
                          " | " +
                          produit['porteFeuille'].toUpperCase()),
                      Text(
                        "FRAIS : " +
                            produit['frais'].toString() +
                            " " +
                            produit['name'].toString() +
                            " = " +
                            (produit['frais'] * produit['prix_achat'])
                                .toString() +
                            " XAF",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'ACHETER CETTE CRYPTO',
                        style: TextStyle(
                            color: Color.fromARGB(255, 200, 151, 2),
                            fontWeight: FontWeight.w900),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ProductPage.routeName,
                          arguments: productModel,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryModel extends ChangeNotifier {
  String _category = 'Tous'; // la catégorie initiale

  // Un getter pour accéder à la catégorie
  String get category => _category;

  // Une méthode pour modifier la catégorie et notifier les écouteurs
  void setCategory(String newCategory) {
    _category = newCategory;
    notifyListeners();
  }
}
//------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------------------//

/*************************** CLASSES COMMENTEES ********************************** */

/*


class ProductCard extends StatefulWidget {
  var produit;

  var onTap;
  ProductCard({super.key, required this.produit, this.onTap});

  // créer une méthode createState qui renvoie une instance de _ProductCardState
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLiked = false; // variable pour stocker l'état du bouton de like

  @override
  Widget build(BuildContext context) {
    ProductModel productModel = ProductModel(
        Category: widget.produit['category'],
        numero: widget.produit['numero'],
        ID: widget.produit['ID'],
        date: widget.produit['date'],
        image: widget.produit['image'],
        prix_achat: widget.produit['price'],
        name: widget.produit['name'],
        quantity: widget.produit['quantity']);
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: widget.onTap ??
                  () {
                    Navigator.pushNamed(
                      context,
                      ProductPage.routeName,
                      arguments: productModel,
                    );
                  },
              child: Container(
                width: 220,
                height: 270,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color.fromARGB(92, 158, 158, 158),
                    borderRadius: BorderRadius.circular(19),
                    image: DecorationImage(
                        image: NetworkImage((widget.produit['image'])),
                        fit: BoxFit.cover)),
              ),
            ),
            //bouton de details
            Positioned(
              left: 8,
              bottom: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // laisser vide pour l'instant
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(62, 0, 0, 0), // couleur du fond
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // bordure arrondie
                      side: BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width:
                              2), // ajouter une bordure blanche de 2 pixels d'épaisseur
                    ),
                  ),
                  child: Text('Détails',
                      style: TextStyle(color: Colors.white)), // texte du bouton
                ),
              ),
            ),

            //bouton de like
            Positioned(
              right: 3,
              top: 3,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked; // changer la valeur de la variable
                  });
                  // modifier le champ score du document du produit dans Firestore
                  FirebaseFirestore.instance
                      .collection('produits')
                      .doc(widget.produit['ID'].toString())
                      .update({
                    'score': FieldValue.increment(isLiked ? 1 : -1),
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                      // choisir l'icône en fonction de la valeur de isLiked
                      Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
                shape: const CircleBorder(),
              ),
            )
          ],
        ),
        Text(
          widget.produit['name'],
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 236, 155, 3),
          ),
        ),
        Text(
          widget.produit['price'].toString() + ' XAF',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 236, 3, 3),
          ),
        ),
      ],
    );
  }
}



 */


/************************************************************** */


/******************************************************************************************************************* */
/* 


class _CategoriesWidget extends StatefulWidget {
  final CategoryModel categoryModel; // déclarer le modèle comme un champ final
  final String selectedCategory; // déclarer la catégorie comme un champ final
  const _CategoriesWidget({
    Key? key,
    required this.categoryModel,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<_CategoriesWidget> createState() => __CategoriesWidgetState();
}

class __CategoriesWidgetState extends State<_CategoriesWidget> {
// Une liste de catégories fictives
  List<Map<String, dynamic>> categories = [
    {'id': 0, 'name': 'Tous', 'icon': Icons.shop},
    {'id': 1, 'name': 'Livres', 'icon': Icons.book},
    {'id': 2, 'name': 'Musique', 'icon': Icons.music_note},
    {'id': 3, 'name': 'Jeux', 'icon': Icons.videogame_asset},
    {'id': 4, 'name': 'Vetements', 'icon': Icons.shopping_basket},
    {'id': 5, 'name': 'Electronique', 'icon': Icons.laptop},
    {'id': 7, 'name': 'Logiciels', 'icon': Icons.android},
    {'id': 6, 'name': 'Autres', 'icon': Icons.add_shopping_cart_sharp},
  ];
  // Accéder au modèle et à la catégorie actuelle

  @override
  Widget build(BuildContext context) {
    var categoryModel = Provider.of<CategoryModel>(context);
    var selectedCategory = categoryModel.category;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, color: Colors.amber),
          ),
          const SizedBox(
            height: 10,
          ),
          // Utiliser un simple ListView.builder sans FutureBuilder
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = categories[index]['name'];
                        // Modifier la catégorie en utilisant le modèle
                        categoryModel.setCategory(categories[index]['name']);
                      });
                    },
                    // Ajouter du style au widget
                    style: ElevatedButton.styleFrom(
                      // Définir la couleur du fond du bouton
                      backgroundColor: selectedCategory ==
                              categories[index]['name']
                          ? Colors
                              .amber // si la catégorie du bouton est égale à la catégorie sélectionnée, mettre la couleur en jaune
                          : Color.fromARGB(
                              94, 0, 0, 0), // sinon, garder la couleur initiale

                      // Définir la taille du bouton

                      // Définir la bordure du bouton
                      side: BorderSide(color: Colors.amber),
                      // Définir le rayon du bord du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // Utiliser une icône et un texte pour afficher la catégorie
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categories[index]['icon'], color: Colors.white),
                        Text(categories[index]['name'],
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


*/

/******************************************************************************************************************** */