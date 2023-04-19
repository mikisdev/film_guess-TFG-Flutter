import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//* FUENTE: https://firebase.google.com/docs/reference/rest/auth?hl=es-419#section-create-email-password
class AuthService extends ChangeNotifier {
  //* Imagen de perfil predefinida
  final pictureUrl =
      'https://steamuserimages-a.akamaihd.net/ugc/795369537926935378/0BA040D30C76B548DD0F9787912948C10D952164/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final storage = const FlutterSecureStorage();

  Future<String?> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      // Creamos un documento para el usuario en la colección "users"
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({'name': name, 'email': email, 'picture': pictureUrl});

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      storage.write(key: 'uid', value: userCredential.user!.uid);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No se encontró un usuario para ese correo electrónico.');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta.');
      }
      return e.code;
    }
  }

  //* Leer uId
  Future<String> readUId() async {
    return await storage.read(key: 'uid') ?? '';
  }

  //*Cerrar sesión
  Future logout() async {
    await storage.deleteAll();
    await _auth.signOut();
  }

  //Todo: Aún está sin usar
  //* Borrar usuario
  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await _auth.currentUser?.delete();
      await storage.deleteAll();
    } catch (e) {
      print(e);
    }
  }

  void notifyListener() {
    notifyListeners();
  }
}
