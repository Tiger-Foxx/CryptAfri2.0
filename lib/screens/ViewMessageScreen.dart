import 'package:cryptafri/screens/models/message.model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ajoutez cette ligne pour importer le modèle de message

class MessageFeedPage extends StatelessWidget {
  const MessageFeedPage({super.key});
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
                          Image.network(message.urlImage),
                        const SizedBox(height: 10),
                        Text(
                          "Le " + message.date.toLocal().toString(),
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucun message pour le moment.'));
          }
        },
      ),
    );
  }
}
