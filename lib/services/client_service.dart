import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client_model.dart';
import '../models/user_model.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'clients';



  // Récupérer un produit par son ID
  Future<Client?> getClientById(userId) async {
    final DocumentSnapshot snapshot = await _firestore.collection(_collectionName).doc(userId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      return Client.fromMap(data) ;
    }
    return null;
  }

  Future<List<Client>> getAllClients() async {
    final QuerySnapshot snapshot = await _firestore.collection(_collectionName).get();
    final List<Client> clients = [];
    for (final DocumentSnapshot doc in snapshot.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final Client client = Client.fromMap(data);
      clients.add(client);
    }
    return clients;
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      // Générer un nouvel ID unique pour le document
      String newUserId = _firestore.collection(_collectionName).doc().id;

      // Ajouter l'ID à l'objet userData
      userData['id'] = newUserId;

      // Ajouter les données de l'utilisateur au document avec le nouvel ID
      await _firestore.collection(_collectionName).doc(newUserId).set(userData);

      print('Utilisateur ajouté avec succès !');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'utilisateur : $e');
    }
  }


  // Mettre à jour un produit par son ID
  Future<void> updateClientById(String id, Map<String, dynamic> data) async {
    await _firestore.collection(_collectionName).doc(id).update(data);
  }

  // Supprimer un produit par son ID
  Future<void> deleteClientById(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}