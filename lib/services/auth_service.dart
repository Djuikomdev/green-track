import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = null;
    await _auth.signOut();
  }

  Future<int?> signInWithEmailAndPassword(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("email: $email , mot de passe: $password");

      // Utiliser userCredential.user pour accéder à l'utilisateur connecté
      print("reussi email");
      prefs.setString('userId',userCredential.user!.uid);

      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 1;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 2;
      }
      print("erreur : $e");
      return 20;
    } catch (e) {
      print(e);
      return 3;
    }
  }

  Future<int?> registerWithEmailAndPassword(
      String email, String password, dataUser) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Utiliser userCredential.user pour accéder à l'utilisateur enregistré
      prefs.setString('userId',userCredential.user!.uid);

      //enregistrement de l'utilisateur dans la collection **users**
      await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({...dataUser, ...{"id":userCredential.user!.uid}});
      // ajout de l'attribut id

      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 2;
      }
    } catch (e) {
      print("erreur de traitement : $e");
      return 3;
    }
  }
}
