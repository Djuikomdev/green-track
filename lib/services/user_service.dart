import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';



  // Récupérer un produit par son ID
  Future<User?> getUserById(userId) async {
    final DocumentSnapshot snapshot = await _firestore.collection(_collectionName).doc(userId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      return User.fromMap(data) ;
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    final List<User> users = [];
    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final User user = User.fromMap(data);
      users.add(user);
    }
    return users;
  }




  // Mettre à jour un produit par son ID
  Future<void> updateUserById(String id, Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).doc(id).update(data);
  }

  // Supprimer un produit par son ID
  Future<void> deleteUserById(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}