import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/models/models.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      body: Stack(
        children: [
          const _Backgorund(),
          CustomScrollView(
            slivers: <Widget>[
              _CustomAppBar(
                movie: movie,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _PosterAndTitle(
                  movie: movie,
                ),
                const SizedBox(
                  height: 25,
                ),
                _Overview(movie: movie),
                CastingCard(
                  movieID: movie.id,
                ),
              ]))
            ],
          ),
        ],
      ),
    );
  }
}

//* Descripcion de la pelicula
class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Text(
        movie.overview,
        textAlign: TextAlign.start,
        style: GoogleFonts.mulish(color: AppTheme.secondaryColor),
      ),
    );
  }
}

//* Portada y título de la pelicula
class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImage),
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headlineSmall!
                      .copyWith(color: AppTheme.secondaryColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.titleMedium!
                      .copyWith(color: AppTheme.secondaryColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline_rounded,
                      size: 15,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${movie.voteAverage}',
                      style: textTheme.bodySmall!
                          .copyWith(color: AppTheme.secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (_) => FavoriteMovieService())
                  ],
                  child: _AddFavoriteIcon(movie: movie),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//* Añadir la película a favoritos
class _AddFavoriteIcon extends StatefulWidget {
  final Movie movie;
  const _AddFavoriteIcon({required this.movie});

  @override
  State<_AddFavoriteIcon> createState() => _AddFavoriteIconState(movie: movie);
}

class _AddFavoriteIconState extends State<_AddFavoriteIcon> {
  final Movie movie;
  bool _isFavorite = false;

  _AddFavoriteIconState({required this.movie});

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    final uid = Provider.of<AuthService>(context, listen: false).readUId();
    final favoriteMovie =
        Provider.of<FavoriteMovieService>(context, listen: false);
    final isFavorite = await favoriteMovie.isFavorite(uid, movie);
    try {
      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthService>(context, listen: false).readUId();
    final favoriteMovie =
        Provider.of<FavoriteMovieService>(context, listen: false);
    return Container(
      alignment: AlignmentDirectional.topEnd,
      child: Row(
        children: [
          Expanded(child: Container()),
          IconButton(
            onPressed: () {
              setState(() {
                if (_isFavorite) {
                  print('Eliminar de favoritos');
                  favoriteMovie.deleteFavorite(uid, movie);
                } else {
                  print('Añadir a favoritos');
                  favoriteMovie.addFavorites(uid, movie);
                  favoriteMovie.getFavoritesMoviesById(uid);
                }
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppTheme.primaryColor,
            ),
          ),
          Text(
            _isFavorite ? '¡Eliminar de favoritos!' : '¡Añadir a favoritos!',
            style:
                const TextStyle(fontSize: 12, color: AppTheme.secondaryColor),
          )
        ],
      ),
    );
  }
}

//* AppBar
class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primaryColor,
      expandedHeight: 200,
      floating: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//*Fondo de la screen
class _Backgorund extends StatelessWidget {
  const _Backgorund();

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 28, 29, 59),
        Color.fromARGB(255, 18, 20, 30)
      ],
    ));
    return Container(
      decoration: boxDecoration,
    );
  }
}
