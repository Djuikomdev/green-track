import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/venter_model.dart';

class VentesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'ventes';

  // Récupérer tous les produits
  Future<List<Sale>> getVentes() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    final List<Sale> sales = [];
    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final Sale sale = Sale.fromMap(data);
      sales.add(sale);
    }
    return sales;
  }

  // Récupérer un produit par son ID
  Future<Map<String, dynamic>?> getVenteById(String id) async {
    final DocumentSnapshot snapshot = await _firestore.collection(_collectionName).doc(id).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  // Créer un nouveau produit
  Future<void> createVente(Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).add(data);
  }

  // Mettre à jour un produit par son ID
  Future<void> updateVenteById(String id, Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).doc(id).update(data);
  }

  // Supprimer un produit par son ID
  Future<void> deleteVenteById(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}
