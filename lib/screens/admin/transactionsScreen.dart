import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:cryptafri/screens/services/fonctions.utiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptafri/screens/models/transaction.model.dart';
import 'package:lottie/lottie.dart';

class TransactionsPage extends StatefulWidget {
  static final String routeName = 'transactions';
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: transactions.orderBy('date', descending: true).snapshots(),
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
                TransactionModel transaction =
                    TransactionModel.fromFirestore(snapshot.data!.docs[index]);

                return GestureDetector(
                  onLongPress: () async {
                    await validerTransaction(transaction.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction validée')),
                    );
                    if (transaction.type.toLowerCase() == 'retrait') {
                      retirerSomme(
                          transaction.emailUtilisateur, transaction.montant);
                    } else {
                      ajouterSomme(
                          transaction.emailUtilisateur, transaction.montant);
                    }
                    FirebaseApi()
                        .sendValiderNotif(transaction.emailUtilisateur);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black87, width: 3),
                      ),
                    ),
                    child: Dismissible(
                      key: Key(transaction.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await supprimerTransaction(transaction.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transaction supprimée')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        tileColor: transaction.valide
                            ? Colors.green
                            : (transaction.type == 'retrait'
                                ? Colors.red
                                : Colors.blue),
                        title: Text(
                          '${transaction.type} - ${transaction.montant.toString()} XAF',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          '${transaction.emailUtilisateur} - ${transaction.numOMMomo}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Column(
                          children: [
                            Text(transaction.date.toString()),
                            Text(
                              "USDT ? : " +
                                  (transaction.addressePorteFeuille == ''
                                      ? "NON"
                                      : "OUI"),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                children: [
                  const Text('AUCUNE TRANSACTION pour le moment...'),
                  Lottie.asset('assets/lotties/bitcoin2.json'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
