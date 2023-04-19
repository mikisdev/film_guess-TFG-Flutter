import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

import '../models/models.dart';

//* Esta clase es la vista de las busquedas
class MovieSearchDelegate extends SearchDelegate {
  //* Texto del appbar
  @override
  String get searchFieldLabel => 'Buscar película';

  //*Tema del appbar
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: colorScheme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor: AppTheme.primaryColor,
        iconTheme:
            theme.primaryIconTheme.copyWith(color: AppTheme.secondaryColor),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  //* Borrar conteido de la busqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.close))
    ];
  }

  //* Volver atrás
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  //* Resultados finales de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    final movieService = Provider.of<MovieService>(context, listen: false);

    return Stack(children: [
      const BackGround(),
      FutureBuilder(
        future: movieService.searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const _EmpySearch();

          final List movies = snapshot.data!;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              return _MovieItem(movie: movies[index]);
            },
          );
        },
      ),
    ]);
  }

  //* Resultados de la busqueda mientras vamos escribiendo
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const _EmpySearch();
    }

    final movieService = Provider.of<MovieService>(context, listen: false);

    return Stack(
      children: [
        const BackGround(),
        FutureBuilder(
          future: movieService.searchMovie(query),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const _EmpySearch();

            final List movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return _MovieItem(movie: movies[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

//* Para cuando no haya resultados en la busqueda
class _EmpySearch extends StatelessWidget {
  const _EmpySearch();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        BackGround(),
        Center(
          child: Icon(
            Icons.movie_outlined,
            color: Colors.black54,
            size: 200,
          ),
        )
      ],
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: movie.id,
        child: ClipRRect(
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImage),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        movie.title,
        style: const TextStyle(color: AppTheme.secondaryColor),
      ),
      subtitle: Text(movie.originalTitle,
          style: const TextStyle(color: AppTheme.secondaryColor)),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}
