import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/models/compte.model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<Compte> getCompte(String email) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('comptes').doc(email).get();

  if (doc.exists) {
    return Compte.fromMap(doc.data() as Map<String, dynamic>);
  } else {
    // Create a new account with default values
    Compte newCompte =
        Compte(email: email, solde: 0.000001, investissement: 0.000001);
    await FirebaseFirestore.instance
        .collection('comptes')
        .doc(email)
        .set(newCompte.toMap());
    return newCompte;
  }
}

Future<void> retirerSomme(String email, double montant) async {
  Compte? compte = await getCompte(email);
  if (compte != null && compte.soldeRetirable >= montant) {
    compte.soldeRetirable -= montant;
    compte.solde = compte.investissement + compte.soldeRetirable;
    compte.updateBalances();
    await FirebaseFirestore.instance
        .collection('comptes')
        .doc(email)
        .update(compte.toMap());
  } else {
    throw Exception('Solde insuffisant ou compte non trouvé.');
  }
}

Future<void> ajouterSomme(String email, double montant) async {
  Compte? compte = await getCompte(email);
  if (compte != null) {
    compte.solde += montant;
    compte.investissement += montant;
    compte.updateBalances();
    await FirebaseFirestore.instance
        .collection('comptes')
        .doc(email)
        .update(compte.toMap());
  } else {
    throw Exception('compte non trouvé.');
  }
}

Future<void> ajouterPourcentageSolde(String email, double pourcentage) async {
  Compte? compte = await getCompte(email);
  if (compte != null) {
    compte.solde += compte.investissement * (pourcentage / 100);

    compte.updateBalances();
    await FirebaseFirestore.instance
        .collection('comptes')
        .doc(email)
        .update(compte.toMap());
  } else {
    throw Exception('Compte non trouvé.');
  }
}

Future<void> ajouterPourcentageTousComptes(double pourcentage) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('comptes').get();
  for (var doc in querySnapshot.docs) {
    Compte compte = Compte.fromMap(doc.data() as Map<String, dynamic>);
    compte.solde += compte.investissement * (pourcentage / 100);
    compte.updateBalances();
    await doc.reference.update(compte.toMap());
  }
}

Future<void> ajouterMontantTousComptes(double montant) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('comptes').get();
  for (var doc in querySnapshot.docs) {
    Compte compte = Compte.fromMap(doc.data() as Map<String, dynamic>);
    compte.solde += montant;
    compte.updateBalances();
    await doc.reference.update(compte.toMap());
  }
}

Future<void> supprimerMessage(String id) async {
  try {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');
    await messages.doc(id).delete();
    print('Message supprimé avec succès!');
  } catch (e) {
    print('Erreur lors de la suppression du message: $e');
  }
}
