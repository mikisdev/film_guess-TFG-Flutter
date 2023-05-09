import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_03/models/models.dart';

import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/widgets/widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteMovieService = Provider.of<FavoriteMovieService>(context);
    final uid = Provider.of<AuthService>(context).readUId();
    return Scaffold(
        body: Stack(
      children: [
        const BackGround(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: FutureBuilder(
              future: favoriteMovieService.getFavoritesMoviesById(uid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Container();

                final movies = snapshot.data!;

                return _Body(
                  movies: movies,
                  onBack: () {
                    setState(() {});
                  },
                );
              },
            ),
          ),
        )
      ],
    ));
  }
}

class _Body extends StatelessWidget {
  final VoidCallback onBack;
  final List<String> movies;
  const _Body({
    super.key,
    required this.movies,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return _MovieCard(
          movieId: movies[index],
          onBack: () => onBack(),
        );
      },
    );
  }
}

//* Card de la pelicula con su portada y titulo
class _MovieCard extends StatelessWidget {
  final VoidCallback onBack;
  final String movieId;
  const _MovieCard({required this.movieId, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final movieService = Provider.of<MovieService>(context);
    return FutureBuilder(
      future: movieService.getMovieById(movieId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Image(image: AssetImage('assets/no-image.jpg'));
        }

        final Movie movie = snapshot.data!;
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, 'details', arguments: movie);
                onBack();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImage),
                  height: 130,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
