import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> validerTransaction(String id) async {
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');
  await transactions.doc(id).update({'valide': true});
}

Future<void> supprimerTransaction(String id) async {
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');
  await transactions.doc(id).delete();
}

String? getUserEmail() {
  var _Auth = FirebaseAuth.instance;

  // Obtenir l'objet User avec un null check
  User user = _Auth.currentUser!;
  // Retourner l'email de l'utilisateur
  return user.email.toString();
}
