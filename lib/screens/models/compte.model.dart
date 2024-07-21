import 'package:cloud_firestore/cloud_firestore.dart';

class Compte {
  String email;
  double solde;
  double soldeUSDT;
  double soldeRetirable;
  double investissement;

  Compte(
      {required this.email,
      required this.solde,
      required this.investissement,
      required this.soldeRetirable})
      : soldeUSDT = (solde / 650).toDouble();

  factory Compte.fromMap(Map<String, dynamic> data) {
    double roundToTwoDecimals(double value) =>
        (value * 100).roundToDouble() / 100;

    return Compte(
      soldeRetirable: roundToTwoDecimals(data['soldeRetirable'].toDouble()),
      email: data['email'],
      solde: roundToTwoDecimals(data['solde'].toDouble()),
      investissement: roundToTwoDecimals(
        data['investissement'].toDouble(),
      ),
    )..updateBalancesLite();
  }

  factory Compte.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    double roundToTwoDecimals(double value) =>
        (value * 100).roundToDouble() / 100;

    return Compte(
      soldeRetirable: roundToTwoDecimals(data['soldeRetirable'].toDouble()),
      email: data['email'],
      solde: roundToTwoDecimals(data['solde'].toDouble()),
      investissement: roundToTwoDecimals(data['investissement'].toDouble()),
    )..updateBalancesLite();
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'solde': solde,
      'soldeUSDT': soldeUSDT,
      'soldeRetirable': soldeRetirable,
      'investissement': investissement,
    };
  }

  void updateBalancesLite() {
    soldeUSDT = (solde / 650).toDouble();
  }

  // Nouvelle méthode updateBalances
  Future<void> updateBalances(QueryDocumentSnapshot? doc) async {
    print("je suis update balance ");
    DateTime threeMonthsAgo =
        DateTime.now().subtract(Duration(days: 90)); // 3 mois = 90 jours

    // Récupérer la dernière transaction de type "investissement" validée
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('emailUtilisateur', isEqualTo: email)
        .where('type', isEqualTo: 'investissement')
        .where('valide', isEqualTo: true)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot lastTransaction = querySnapshot.docs.first;
      DateTime lastInvestmentDate =
          (lastTransaction['date'] as Timestamp).toDate();

      // Si la dernière transaction date de plus de 3 mois
      if (lastInvestmentDate.isBefore(threeMonthsAgo)) {
        double lastInvestmentAmount =
            (((lastTransaction['montant'] as int)) * 0.98) + 0.0;

        // Ajouter le montant de cette transaction au solde retirable
        soldeRetirable += lastInvestmentAmount;
        print("solde retirable : $soldeRetirable + $lastInvestmentAmount");

        // Invalider la transaction
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(lastTransaction.id)
            .update({'valide': false});

        // Mettre à jour l'investissement à 0.0
        investissement = 0.0;
      }
    }

    // Calculer le soldeUSDT
    soldeUSDT = (solde / 650).toDouble();
    await FirebaseFirestore.instance
        .collection('comptes')
        .doc(email)
        .update(this.toMap());
    if (doc != null) {
      await doc.reference.update(this.toMap());
    }
  }
}
