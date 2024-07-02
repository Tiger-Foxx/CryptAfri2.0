import 'package:flutter/material.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:cryptafri/screens/sign-in_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Définir la classe SellItem avec le champ ID
class SellItem {
  SellItem({
    this.id,
    required this.name,
    required this.price,
    required this.score,
    required this.image,
  });

  String? id; // L'identifiant du produit
  final String image; // L'image du produit
  final String name; // Le nom du produit
  final int price; // Le prix du produit
  final int score; // La quantité du produit
}

// Créer une classe CartScreen qui représente la screen du panier
class SellsScreen extends StatefulWidget {
  static const routeName = 'sells';

  @override
  State<SellsScreen> createState() => _SellsScreenState();
}

class _SellsScreenState extends State<SellsScreen> {
  // Obtenir l'email de l'utilisateur courant
  String? getUserEmail() {
    var Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email.toString();
  }

// Créer une référence à la collection 'produits'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes ventes "),
        centerTitle: true,
        backgroundColor: Color.fromARGB(172, 0, 0, 0),
        foregroundColor: Colors.white54,
      ),
      backgroundColor: Color.fromARGB(172, 0, 0, 0),
      body: Column(
        children: [
          // Créer un widget Expanded qui occupe tout l'espace disponible

          Expanded(
              // Créer un widget ListView qui affiche la liste des produits dans le panier
              child: Container(
            constraints: const BoxConstraints(maxHeight: 350, minHeight: 300),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('produits')
                    .where('email vendeur',
                        isEqualTo:
                            getUserEmail()) // si oui, utiliser un filtre sur la requête firebase pour récupérer les produits de la catégorie correspondante
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return productCard(
                            produit: snapshot.data!.docs[index],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Lottie.asset('assets/lotties/astronot.json'),
                            Text('Une erreur est survenue'),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          children: [
                            const Text("vous n'avez rien vendu pour le moment"),
                            Lottie.asset('assets/lotties/chercher.json',
                                fit: BoxFit.cover, animate: true),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                    return Column(
                      children: [
                        const Text(
                            "vous n'avez rien vendu pour le moment o erreur possible ",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 18)),
                        SizedBox(
                          height: 280,
                          child: Lottie.asset('assets/lotties/chercher.json',
                              fit: BoxFit.contain),
                        ),
                      ],
                    );
                  }
                }),
          )),
          SizedBox(
            height: 100,
            width: 100,
            child: Lottie.asset('assets/lotties/cart.json'),
          ),
          // Créer un widget Container qui affiche le titre de l'ecran
          Container(
            height: 80, // La hauteur du conteneur
            color: Color.fromARGB(255, 221, 166, 3), // La couleur du conteneur
            padding:
                EdgeInsets.all(16), // Ajouter un peu d'espace autour du contenu
            child: Row(
              // Créer un widget Row qui aligne les éléments horizontalement
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Espacer les éléments également
              children: [
                // Créer un widget Text qui affiche le total du panier
                Flexible(
                  child: const Text(
                    'Vos Ventes', // Le texte à afficher
                    style: TextStyle(
                      // Le style du texte
                      color: Colors.white, // Une couleur blanche pour le texte
                      fontSize: 18, // Une taille de 24 pixels pour le texte
                      fontWeight:
                          FontWeight.bold, // Une graisse en gras pour le texte
                    ),
                  ),
                ),
                // Créer un widget ElevatedButton qui permet de signaler un soucis
                ElevatedButton.icon(
                  icon: Icon(Icons.signal_cellular_0_bar),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  label: Text(
                      "revenir à l'Acceuil"), // Le texte à afficher sur le bouton
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class productCard extends StatefulWidget {
  productCard({super.key, required this.produit});

  var produit;

  @override
  State<productCard> createState() => _productCardState();
}

class _productCardState extends State<productCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Dismissible(
        key: ValueKey(
            widget.produit['ID']), // Une clé unique pour identifier l'élément
        direction: DismissDirection.endToStart, // La direction du glissement
        onDismissed: (direction) {
          // La fonction à appeler lorsque l'élément est supprimé
          // Supprimer l'élément de la liste
          FirebaseFirestore.instance
              .collection('produits')
              .doc(widget.produit['ID'])
              .delete();

          // Afficher un message de confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  widget.produit['name'] + ' a été supprimé du marché',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                )),
          );
        },
        background: Container(
          // Le widget à afficher derrière l'élément lors du glissement
          color: Colors.red, // Une couleur rouge pour indiquer la suppression
          alignment: Alignment.centerRight, // Aligner le contenu à droite
          padding:
              EdgeInsets.only(right: 16), // Ajouter un peu d'espace à droite
          child: Icon(
            Icons.delete, // Une icône de corbeille
            color: Colors.white, // Une couleur blanche pour l'icône
          ),
        ),
        child: Column(
          children: [
            ListTile(
              // Le widget à afficher pour l'élément de la liste
              leading: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  widget.produit['image'],
                  fit: BoxFit.cover,
                ),
              ), // L'image du produit à gauche
              title: Text(
                widget.produit['name'],
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ), // Le nom du produit au centre
              subtitle: Text(
                widget.produit['price'].toString() + ' XAF',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.amber),
              ), // Le prix du produit en dessous du nom
              trailing: Text(
                'score : ' + widget.produit['score'].toString(),
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ), // La quantité du produit à droite
            ),
            SizedBox(
                height: 5,
                child: Container(
                  decoration: BoxDecoration(color: Colors.amber),
                )),
          ],
        ),
      ),
    );
  }
}
