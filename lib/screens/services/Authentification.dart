import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/USER.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Authentification {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  USER? userfromFireBase(User? user) {
    return user != null ? USER(uid: user.uid, email: user.email) : null;
  }

  Stream<USER?> get user {
    return _auth.authStateChanges().map(userfromFireBase);
  }

  Future<String?> getToken() async {
    // Obtenez une instance des préférences partagées
    final prefs = await SharedPreferences.getInstance();
    // Récupérez le jeton avec la clé
    String? token = prefs.getString('token');
    // Retournez le jeton ou null si non trouvé
    return token;
  }

  Future<void> saveToken(String? token) async {
    // Obtenez une instance des préférences partagées
    final prefs = await SharedPreferences.getInstance();
    // Enregistrez le jeton avec une clé
    await prefs.setString('token', (token ?? ''));
  }

//fonction qui connecte un user
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? token = await result.user?.getIdToken();
      await saveToken(token);
      var user = userfromFireBase(result.user);
      return user;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

//fonction qui enregistre un User
  Future signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = userfromFireBase(result.user);
      return user;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  // fonction de deloggage

  Future signOut(String email, String password) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future GoogleSignUp() async {
    // Déclencher le flux de connexion Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // Obtenir les détails d'authentification du compte Google
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Créer une nouvelle référence d'authentification Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Se connecter avec la référence d'authentification Firebase
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    String? token = await userCredential.user?.getIdToken();
    await saveToken(token);
    // Retourner l'utilisateur connecté
    return userfromFireBase(userCredential.user);
  }
}
