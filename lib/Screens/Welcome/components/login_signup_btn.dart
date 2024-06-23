import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/button.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';
import 'data.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButon(

          onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ),
          );
        }, title: 'Se connecter', color: Colors.green,),

        const SizedBox(height: 16),
        CustomButon(
          onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const SignUpScreen();
              },
            ),
          );
        }, title: 'S\'inscrire', color: Colors.amberAccent,
        ),
        // TextButton(
        //     onPressed: ()async{
        //       final FirebaseFirestore firestore = FirebaseFirestore.instance;
        //       final collectionRef = firestore.collection('bouteilles');
        //
        //       try {
        //         // Vérification de l'existence des produits
        //         final snapshot = await collectionRef.get();
        //         final existingIds = snapshot.docs.map((doc) => doc.id).toSet();
        //
        //         // Ajout des produits en un seul appel batch
        //         final batch = firestore.batch();
        //         var i = 0;
        //         for (final produit in bottles1) {
        //           final docRef = collectionRef.doc();
        //           if (!existingIds.contains(docRef.id)) {
        //             batch.set(docRef, {...produit,...{
        //               "state": "vide",
        //               "localisation": "magasin",
        //               "rack": "indisponible",
        //               "date": ""
        //             }});
        //             print("pourentage : ${i}% /6238");
        //             i++;
        //           } else {
        //             print('Le produit ${docRef.id} existe déjà, il ne sera pas ajouté.');
        //           }
        //         }
        //         await batch.commit();
        //         print('Produits ajoutés avec succès.');
        //       } catch (e) {
        //         print('Erreur lors de l\'ajout des produits : $e');
        //       }
        //     },
        //     child: Text("traiter le document Excel"))

      ],
    );
  }
}
