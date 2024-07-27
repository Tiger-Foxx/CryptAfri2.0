import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  static const routeName = 'forgot';
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Un email de recupération de mot de passe sera envoyé à votre adresse e-mail.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Adresse e-mail'),
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez entrer votre adresse e-mail';
                      }
                      if (!value.contains('@')) {
                        return 'L\'adresse e-mail n\'est pas valide';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Envoyer'),
                    onPressed: () {
                      print(_formKey.currentState);
                      if (_formKey.currentState!.validate()) {
                        _sendPasswordResetEmail();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendPasswordResetEmail() {
    print('Sending password reset email to $_email...');
    FirebaseAuth.instance.sendPasswordResetEmail(email: _email ?? '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Un email de réinitialisation de mot de passe a été envoyé.'),
      ),
    );
  }
}
