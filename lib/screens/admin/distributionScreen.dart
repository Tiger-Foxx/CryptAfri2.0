import 'package:cryptafri/screens/services/fonctions.utiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DistributionPage extends StatefulWidget {
  @override
  _DistributionPageState createState() => _DistributionPageState();
  static const routeName = 'distribution';
}

class _DistributionPageState extends State<DistributionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _isPourcentage = true;

  Future<void> _updateBalances() async {
    double value = double.parse(_controller.text);
    if (_isPourcentage) {
      await ajouterPourcentageTousComptes(value);
    } else {
      await ajouterMontantTousComptes(value);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Mise à jour effectuée avec succès'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            'Distribuer',
            style: TextStyle(fontWeight: FontWeight.w800),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Ici vous distribuez les gains aux utilisateurs , vous avez le choix entre leurs augmenter un certain pourcentage , ou leur augmenter une certaine somme , notez que vous pouvez mettre un pourcentage negatif dans la mesure ou vous voulez diminuer leur solde \n(suite aune erreur par exemple)",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                          labelText: _isPourcentage
                              ? 'Ajouter Pourcentage'
                              : 'Ajouter Montant'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une valeur';
                        }
                        return null;
                      },
                    ),
                    SwitchListTile(
                      title: Text('Pourcentage / Montant'),
                      value: _isPourcentage,
                      onChanged: (bool value) {
                        setState(() {
                          _isPourcentage = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateBalances();
                        }
                      },
                      child: Text('Mettre à jour les soldes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
