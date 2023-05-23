import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tfg_03/models/models.dart';
import 'package:tfg_03/services/services.dart';

class MovieService extends ChangeNotifier {
  //*Conexión a la api
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '1a0efb7c0bd15a465d108a01c212b74c';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  Map<int, List<Cast>> movieCast = {};

  MovieService() {
    getOnDisplayMovie();
  }

  //* Response body que recibo de la api
  Future<String> _getJasonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endPoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  //* Obtenemos las peliculas que hay en cartelera
  getOnDisplayMovie() async {
    try {
      final jsonData = await _getJasonData('3/movie/now_playing');

      final nowPlayingResponse = NowPlayingResponse.fromRawJson(jsonData);

      onDisplayMovies = nowPlayingResponse.results;
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbar('Error de conexión', Colors.red);
    }
  }

  //* Obtenemos la lista de actores de una pelicula
  Future<List<Cast>> getMovieCast(int movieID) async {
    //* guardar los actores en el cache
    if (movieCast.containsKey(movieID)) return movieCast[movieID]!;

    final jsonData = await _getJasonData('3/movie/$movieID/credits');

    final creditsResponse = CreditsResponse.fromRawJson(jsonData);
    movieCast[movieID] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  //* Busqueda
  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromRawJson(response.body);

    return searchResponse.results;
  }

  //* Para obtener una pelicula por id
  Future<Movie?> getMovieById(String id) async {
    try {
      final url = Uri.https(
          _baseUrl, '3/movie/$id', {'api_key': _apiKey, 'language': _language});
      final response = await http.get(url);

      final movie = Movie.fromRawJson(response.body);

      return movie;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //* Para generar una pelicula aleatoria
  Future<Movie?> getRandomMovie() async {
    int randomPage;
    int randomIndex;
    String jsonData;
    List<Movie> movies;
    Movie movie;

    do {
      randomPage = 1 + Random().nextInt(100);
      jsonData = await _getJasonData('3/movie/popular', randomPage);

      var popularMoviesResponse = PopularResponse.fromRawJson(jsonData);

      movies = popularMoviesResponse.results;

      randomIndex = 1 + Random().nextInt(movies.length);

      movie = movies[randomIndex - 1];
    } while (movie.posterPath == null ||
        movie.originalLanguage == 'cn' ||
        movie.originalLanguage == 'ko' ||
        movie.originalLanguage == 'it');

    print('RANDOM ${movie.title} ${movie.originalLanguage}');

    return movie;
  }
}
