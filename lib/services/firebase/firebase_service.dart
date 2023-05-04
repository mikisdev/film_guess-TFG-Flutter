import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireBaseService extends ChangeNotifier {
  Future updatePictureAndName(
      Future<String> uid, String name, String picture) async {
    final id = await uid;
    await db
        .collection('users')
        .doc(id)
        .update({'name': name, 'picture': picture});
  }

  Future updateName(Future<String> uid, String name) async {
    final id = await uid;
    await db.collection('users').doc(id).update({'name': name});
  }

  Future updatePicture(Future<String> uid, String picture) async {
    final id = await uid;
    await db.collection('users').doc(id).update({'picture': picture});
  }
}

FirebaseFirestore db = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> getUserData(Future<String> uid) async {
  final id = await uid;
  final userRef = FirebaseFirestore.instance.collection('users').doc(id);
  final userData = await userRef.get();
  if (userData.exists) {
    print(userData.data());
    return userData.data();
  } else {
    return null;
  }
}
