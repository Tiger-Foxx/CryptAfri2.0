import 'package:cryptafri/screens/InfosScreen.dart';
import 'package:cryptafri/screens/models/message.model.dart';
import 'package:cryptafri/screens/services/fonctions.utiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart'; // Ajoutez cette ligne pour importer le modèle de message

class MessageFeedPage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  MessageFeedPage({super.key});

  void _showDeleteConfirmationDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await supprimerMessage(messageId);
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text('Message supprimé avec succès!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  static final String routeName = 'viewMessage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(56, 255, 193, 7),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'DU NOUVEAU',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                MessageModel message =
                    MessageModel.fromFirestore(snapshot.data!.docs[index]);

                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onLongPress: () async {
                      if (getUserEmail() == InfosPage.email) {
                        _showDeleteConfirmationDialog(context, message.id);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By - ADMIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            message.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          if (message.urlImage.isNotEmpty)
                            FadeInImage(
                              placeholder: AssetImage('assets/images/0.jpg'),
                              image: NetworkImage(message.urlImage),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://a.c-dn.net/c/content/dam/publicsites/sgx/images/Email/Trading_Cryptocurrencies_Effectively_Using_PriceAction.jpg/jcr:content/renditions/original-size.webp',
                                  fit: BoxFit.cover,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 10),
                          Text(
                            "Le " + message.date.toLocal().toString(),
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.asset('assets/lotties/chercher.json',
                          fit: BoxFit.contain),
                    ),
                    Center(
                        child: Text(
                      'Aucun message pour le moment.',
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
