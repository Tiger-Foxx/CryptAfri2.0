import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/models/compte.model.dart';
import 'package:cryptafri/screens/models/transaction.model.dart';
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
    Compte newCompte = Compte(
        email: email,
        solde: 0.000001,
        investissement: 0.000001,
        soldeRetirable: 0.000001);
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
    compte.solde -= montant;
    compte.soldeRetirable -= montant;
    compte.updateBalances(null);
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
    compte.updateBalances(null);
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
    compte.soldeRetirable +=
        (compte.investissement * (pourcentage / 100)) * .98;
    compte.updateBalances(null);
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
    compte.soldeRetirable +=
        (compte.investissement * (pourcentage / 100)) * .98;
    await doc.reference.update(compte.toMap());

    compte.updateBalances(doc);
    //await doc.reference.update(compte.toMap());
  }
}

Future<void> ajouterMontantTousComptes(double montant) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('comptes').get();
  for (var doc in querySnapshot.docs) {
    Compte compte = Compte.fromMap(doc.data() as Map<String, dynamic>);
    compte.solde += montant;
    compte.soldeRetirable += montant;
    compte.updateBalances(null);
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

// Fonction pour vérifier si l'utilisateur a un investissement validé qui date de plus de 3 mois
Future<bool> hasInvestmentOlderThan3Months(String email) async {
  DateTime threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('emailUtilisateur', isEqualTo: email)
      .where('type', isEqualTo: 'investissement')
      .where('valide', isEqualTo: true)
      .get();

  for (var doc in querySnapshot.docs) {
    TransactionModel transaction = TransactionModel.fromFirestore(doc);
    if (transaction.date.isBefore(threeMonthsAgo)) {
      return true;
    }
  }
  return false;
}

// Fonction pour récupérer le montant total des investissements retirables
Future<double> getTotalRetirableInvestment(String email) async {
  DateTime threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('emailUtilisateur', isEqualTo: email)
      .where('type', isEqualTo: 'investissement')
      .where('valide', isEqualTo: true)
      .get();

  double totalRetirable = 0.0;
  for (var doc in querySnapshot.docs) {
    TransactionModel transaction = TransactionModel.fromFirestore(doc);
    if (transaction.date.isBefore(threeMonthsAgo)) {
      totalRetirable += transaction.montant;
    }
  }
  return totalRetirable;
}

// Fonction pour retirer une somme de l'investissement
Future<void> retirerInvestissement(String email, double montantARetirer) async {
  double totalRetirable = await getTotalRetirableInvestment(email);

  if (montantARetirer > totalRetirable) {
    throw Exception('Montant à retirer dépasse le montant retirable.');
  }

  DateTime threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('emailUtilisateur', isEqualTo: email)
      .where('type', isEqualTo: 'investissement')
      .where('valide', isEqualTo: true)
      .get();

  double montantRestant = montantARetirer;
  for (var doc in querySnapshot.docs) {
    TransactionModel transaction = TransactionModel.fromFirestore(doc);
    if (transaction.date.isBefore(threeMonthsAgo) && montantRestant > 0) {
      double montantUtilise = (transaction.montant > montantRestant)
          ? montantRestant
          : transaction.montant;
      montantRestant -= montantUtilise;

      // Invalider la transaction
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transaction.id)
          .update({'valide': false});

      // Mettre à jour le compte utilisateur
      DocumentSnapshot compteDoc = await FirebaseFirestore.instance
          .collection('comptes')
          .doc(email)
          .get();

      if (compteDoc.exists) {
        Compte compte = Compte.fromFirestore(compteDoc);
        compte.investissement -= montantUtilise;
        compte.solde -= montantUtilise;
        compte.updateBalances(null);

        await FirebaseFirestore.instance
            .collection('comptes')
            .doc(email)
            .update(compte.toMap());
      } else {
        throw Exception('Compte non trouvé.');
      }
    }
  }
}

// Fonction pour vérifier si le dernier investissement date de plus de 3 mois
Future<bool> Peu_investir(String email) async {
  DateTime threeMonthsAgo =
      DateTime.now().subtract(Duration(days: 90)); // 3 mois = 90 jours
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('emailUtilisateur', isEqualTo: email)
      .where('type', isEqualTo: 'investissement')
      .where('valide', isEqualTo: true)
      .orderBy('date', descending: true)
      .limit(1)
      .get();
  print("je marche encore ici");
  if (querySnapshot.docs.isEmpty) {
    return true; // Pas de transactions, peut investir
  }

  DocumentSnapshot lastTransaction = querySnapshot.docs.first;
  DateTime lastInvestmentDate = (lastTransaction['date'] as Timestamp).toDate();
  bool rep = lastInvestmentDate.isBefore(threeMonthsAgo);
  print("tu peu investir : $rep");
  return rep;
}
