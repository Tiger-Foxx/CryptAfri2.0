import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String numOMMomo;
  String addressePorteFeuille;
  DateTime date;
  String emailUtilisateur;
  double montant;
  String nomCompte;
  String type;
  bool valide;
  String whatsapp;

  TransactionModel({
    required this.id,
    required this.numOMMomo,
    required this.addressePorteFeuille,
    required this.date,
    required this.emailUtilisateur,
    required this.montant,
    required this.nomCompte,
    required this.type,
    required this.valide,
    required this.whatsapp,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      numOMMomo: data['NumOM_MOMO'] ?? '',
      addressePorteFeuille: data['AddressePorteFeuille'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      emailUtilisateur: data['emailUtilisateur'] ?? '',
      montant: data['montant'].toDouble() ?? 0.0,
      nomCompte: data['nomCompte'] ?? '',
      type: data['type'] ?? '',
      valide: data['valide'] ?? false,
      whatsapp: data['whatsapp'] ?? '',
    );
  }
}
