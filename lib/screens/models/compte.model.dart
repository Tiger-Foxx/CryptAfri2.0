import 'package:cloud_firestore/cloud_firestore.dart';

class Compte {
  String email;
  double solde;
  double soldeUSDT;
  double soldeRetirable;

  Compte({required this.email, required this.solde})
      : soldeUSDT = (solde / 650).toDouble(),
        soldeRetirable = (solde * 0.98).toDouble();

  factory Compte.fromMap(Map<String, dynamic> data) {
    double roundToTwoDecimals(double value) =>
        (value * 100).roundToDouble() / 100;

    return Compte(
      email: data['email'],
      solde: roundToTwoDecimals(data['solde'].toDouble()),
    )..updateBalances();
  }

  factory Compte.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    double roundToTwoDecimals(double value) =>
        (value * 100).roundToDouble() / 100;

    return Compte(
      email: data['email'],
      solde: roundToTwoDecimals(data['solde'].toDouble()),
    )..updateBalances();
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'solde': solde,
      'soldeUSDT': soldeUSDT,
      'soldeRetirable': soldeRetirable,
    };
  }

  void updateBalances() {
    soldeUSDT = (solde / 650).toDouble();
    soldeRetirable = (solde * 0.98).toDouble();
  }
}
