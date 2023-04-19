import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tfg_03/models/models.dart';

import 'firebase_service.dart';

class FavoriteMovieService extends ChangeNotifier {
  Future addFavorites(Future<String> uid, Movie movie) async {
    final id = await uid;
    await db
        .collection('users')
        .doc(id)
        .collection('peliculas')
        .doc('${movie.id}')
        .set({'title': movie.title});
  }

  Future deleteFavorite(Future<String> uid, Movie movie) async {
    final id = await uid;

    await db
        .collection('users')
        .doc(id)
        .collection('peliculas')
        .doc('${movie.id}')
        .delete();
  }

  Future<bool> isFavorite(Future<String> uid, Movie movie) async {
    final id = await uid;

    try {
      DocumentSnapshot snapshot = await db
          .collection('users')
          .doc(id)
          .collection('peliculas')
          .doc('${movie.id}')
          .get();
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getFavoritesMoviesById(Future<String> uid) async {
    try {
      final id = await uid;

      List<String> movieListId = [];

      QuerySnapshot peliculasSnapshot =
          await db.collection('users').doc(id).collection('peliculas').get();

      peliculasSnapshot.docs.forEach((peliculaDoc) {
        movieListId.add(peliculaDoc.id);
      });

      print('AAAA $movieListId');
      notifyListeners();
      return movieListId;
    } catch (e) {
      print(e);

      return [];
    }
  }
}
