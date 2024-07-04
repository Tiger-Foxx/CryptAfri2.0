import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'dart:math';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({super.key});
  static final String routeName = 'sendMessage';

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlImageController = TextEditingController();
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

  Future<void> _sendMessage() async {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

    await messages.add({
      'ID': _contentController.text ?? "" + generateId(),
      'date': Timestamp.fromDate(DateTime.now()),
      'content': _contentController.text,
      'url_image': _urlImageController.text ??
          "https://a.c-dn.net/c/content/dam/publicsites/sgx/images/Email/Trading_Cryptocurrencies_Effectively_Using_PriceAction.jpg/jcr:content/renditions/original-size.webp",
    });

    FirebaseApi().sendMessageToAllUsers(
        _contentController.text, _urlImageController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message envoyé avec succès!'),
        backgroundColor: Colors.green,
      ),
    );

    _contentController.clear();
    _urlImageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer un Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _urlImageController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'image',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Diffuser'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
