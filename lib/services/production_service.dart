import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'production';

  // Récupérer tous les produits
  Future<List<Map<String, dynamic>>> getProductions() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Récupérer un produit par son ID
  Future<Map<String, dynamic>?> getProductionById(String id) async {
    final DocumentSnapshot snapshot = await _firestore.collection(_collectionName).doc(id).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  // Créer un nouveau produit
  Future<void> createProduction(Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).add(data);
  }

  // Mettre à jour un produit par son ID
  Future<void> updateproductionById(String id, Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).doc(id).update(data);
  }

  // Supprimer un produit par son ID
  Future<void> deleteProductionById(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}
