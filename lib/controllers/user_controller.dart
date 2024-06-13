import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<User> getUserById(String id) async {
    DocumentSnapshot userSnapshot = await _userCollection.doc(id).get();
    Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      return User.fromMap(data);
    } else {
      throw Exception('User not found');
    }
  }
}
//
