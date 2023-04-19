import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tfg_03/search/movie_search_delegate.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieService = Provider.of<MovieService>(context);
    return Scaffold(
        drawer: const DrawerMenu(),
        appBar: AppBar(
          title: const Text(
            'Film Guess',
            style: TextStyle(color: AppTheme.secondaryColor),
          ),
          actions: [
            //*Icono para buscar peliculas
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                color: AppTheme.secondaryColor,
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: Stack(
          children: [
            //*Fondo
            const BackGround(),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),

                //* Portadas películas
                CardSwiper(
                  movies: movieService.onDisplayMovies,
                ),
                const SizedBox(
                  height: 50,
                ),

                //*Botón para jugar
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'game');
                  },
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 115, 57, 239)),
                    elevation: MaterialStateProperty.all<double>(8),
                    shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.8)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                  ),
                  child: const Text(
                    '¡A JUGAR!',
                    style: TextStyle(
                      fontSize: 30,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
