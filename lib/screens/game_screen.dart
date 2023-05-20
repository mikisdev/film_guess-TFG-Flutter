import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/models/models.dart';
import 'package:tfg_03/providers/providers.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieService = Provider.of<MovieService>(context);

    return Scaffold(
      body: Stack(
        children: [
          const _Backgorund(),
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => GuessGameProvider())
            ],
            child: FutureBuilder(
              future: movieService.getRandomMovie(),
              builder: (BuildContext context, AsyncSnapshot<Movie?> snapshot) {
                if (!snapshot.hasData) return Container();

                Movie movie = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    _PosterImage(poster: movie.fullPosterImage),
                    const SizedBox(
                      height: 50,
                    ),
                    _Form(movie: movie)
                  ]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//* Poster de la pélicula pixelado
class _PosterImage extends StatelessWidget {
  final String poster;
  const _PosterImage({
    super.key,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    final guessGameProvider = Provider.of<GuessGameProvider>(context);
    final size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        height: size.height * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
                sigmaX: guessGameProvider.sigma,
                sigmaY: guessGameProvider.sigma),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(poster),
              fit: BoxFit.cover,
            ),
          ),
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

//* Formo donde adivinaremos la película
class _Form extends StatelessWidget {
  final Movie movie;
  const _Form({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final guessGameProvider = Provider.of<GuessGameProvider>(context);
    guessGameProvider.movie = movie.title;
    return Form(
        key: guessGameProvider.formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                _TypeAheadForm(guessGameProvider: guessGameProvider),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(8),
                          shadowColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 87, 43, 180)
                                .withOpacity(0.8),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        onPressed: () {
                          bool win;
                          bool lost;
                          if (!guessGameProvider.isValidForm()) return;

                          guessGameProvider.guess =
                              guessGameProvider.guess.toLowerCase();

                          guessGameProvider.movie =
                              guessGameProvider.movie.toLowerCase();

                          guessGameProvider.isFail();

                          win = guessGameProvider.win;
                          lost = guessGameProvider.lost;

                          print(guessGameProvider.sigma);

                          if (win) {
                            Navigator.pushReplacementNamed(context, 'victory',
                                arguments: movie);
                          }
                          if (lost) {
                            Navigator.pushReplacementNamed(context, 'lost',
                                arguments: movie);
                          }
                        },
                        child: const Text(
                          'ADIVINAR',
                          style: TextStyle(fontSize: 20),
                        )))
              ],
            )));
  }
}

//* Sugerencias según vas escribiendo
class _TypeAheadForm extends StatefulWidget {
  const _TypeAheadForm({
    super.key,
    required this.guessGameProvider,
  });

  final GuessGameProvider guessGameProvider;

  @override
  State<_TypeAheadForm> createState() => _TypeAheadFormState();
}

class _TypeAheadFormState extends State<_TypeAheadForm> {
  @override
  Widget build(BuildContext context) {
    final movieService = Provider.of<MovieService>(context);
    final TextEditingController typeAheadController = TextEditingController();
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          controller: typeAheadController,
          onChanged: (value) => widget.guessGameProvider.guess = value,
          style: const TextStyle(color: AppTheme.secondaryColor)),
      onSuggestionSelected: (Movie movie) {
        // Actualiza el valor del controlador de texto con el título de la película seleccionada
        widget.guessGameProvider.guess = movie.title;
        typeAheadController.text = movie.title;
        print('Película seleccionada: ${movie.title}');
      },
      itemBuilder: (BuildContext context, Movie movie) {
        return ListTile(
          title: Text(
            movie.title,
          ),
        );
      },
      suggestionsCallback: (query) => movieService.searchMovie(query),
      hideSuggestionsOnKeyboardHide: false,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
          color: Colors.deepPurple,
          elevation: 4.0,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
    );
  }
}
