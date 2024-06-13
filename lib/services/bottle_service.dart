import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bottle_model.dart';

class BouteilleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'bouteilles';

  // Récupérer tous les produits
  Future<List<Bottle>> getBottles() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    final List<Bottle> bottles = [];
    //var i = 1;
    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final Bottle bottle = Bottle.fromMap(data);
      //print("$data,");
      bottles.add(bottle);
      //i++;
    }
    return bottles;
  }

  // Récupérer un produit par son ID
  Future<Map<String, dynamic>?> getBottleById(String id) async {
    final DocumentSnapshot snapshot = (await _firestore.collection(_collectionName).where("nb_bottle", isEqualTo: id).get()) as DocumentSnapshot<Object?>;
    try{
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    }catch(e){
      print("erreur de requete: $e");
    }
    return null;
  }

  // Créer un nouveau produit
  Future<void> createBottle(Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).add(data);
  }

  // Mettre à jour un produit par son ID
  Future<void> updateBottleById(String id, Map<String, dynamic> data) async {
    final collectionRef = _firestore.collection(_collectionName);

    // Query to find the document based on age
    final querySnapshot = await collectionRef.where('nb_bottle', isEqualTo: data['nb_bottle']).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Get the document ID of the first matching document
      final documentId = querySnapshot.docs[0].id;

      // Update the document using the document ID
      await collectionRef.doc(documentId).update(data);
    } else {
      // No document found with the specified age
      print('Aucun document trouvé avec l\'âge spécifié: ${data['age']}');
    }
  }

  // Supprimer un produit par son ID
  Future<void> deleteBottleById(String nbBottle) async {
    final collectionRef = _firestore.collection(_collectionName);

    // Query to find the document named "toto"
    final querySnapshot = await collectionRef.where('nb_bottle', isEqualTo: nbBottle).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Get the document ID of the first matching document
      final documentId = querySnapshot.docs[0].id;

      // Delete the document using the document ID
      await collectionRef.doc(documentId).delete();
    }
  }
}
