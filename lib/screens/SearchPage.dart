import 'package:flutter/material.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:cryptafri/screens/sign-in_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search_page/search_page.dart';

class Person implements Comparable<Person> {
  const Person(this.name, this.surname, this.age);

  final num age;
  final String name, surname;

  @override
  int compareTo(Person other) => name.compareTo(other.name);
}

class Produit implements Comparable<Produit> {
  Produit(this.name, this.price, this.score, this.date, this.ID);
  String name, ID;
  int price, score;
  var date;
  @override
  int compareTo(Produit other) => name.compareTo(other.name);
  void afficher() {
    print(name);
    print(score);
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const routeName = 'search';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  static const people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
    Person('seettee', 'zzzz', 39),
  ];

  List<Produit> recupProduits() {
    List<Produit> produits = [];

    // conexion à firebase
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection("produits");
    // récupération des données de la base de donnée et stock dans une liste
    collection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // extraction des données du document
        var data = doc.data();
        var name = data["name"];
        var ID = data["ID"];
        var date = data["date"];
        var score = data["score"];
        var price = data["price"];

        //creation d'un objet produit
        var produit = Produit(name, price, score, date, ID);

        // Ajout du produit à la liste
        produits.add(produit);
      });
    });

    return produits;
  }

  @override
  Widget build(BuildContext context) {
    var products = recupProduits();
    for (var element in products) {
      element.afficher();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final produit = products[index];

          return GestureDetector(
            onTap: () {
              print("hello");
            },
            child: ListTile(
              title: Text(produit.name),
              subtitle: Text(produit.score.toString()),
              trailing: Text('${produit.price} XAF'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search product',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage(
            onQueryUpdate: print,
            items: products,
            searchLabel: 'Search Products',
            suggestion: const Center(
              child: Text('Filter products by name, price or score'),
            ),
            failure: Center(
              child: Lottie.asset('assets/lotties/astronot.json'),
            ),
            filter: (produit) => [
              produit.name,
              produit.price.toString(),
              produit.score.toString(),
            ],
            sort: (a, b) => a.compareTo(b),
            builder: (produit) => ListTile(
              title: Text(produit.name),
              subtitle: Text(produit.score.toString()),
              trailing: Text('${produit.price} XAF'),
            ),
          ),
        ),
        child: const Icon(Icons.search),
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

          // Afficher un message de confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  widget.produit['name'] +
                      ' a été supprimé du comme proposition',
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
