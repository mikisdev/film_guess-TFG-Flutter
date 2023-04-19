import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/providers/providers.dart';
import 'package:tfg_03/themes/app_theme.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String movie = 'Mario';
    return Scaffold(
        body: Stack(
      children: [
        const _Backgorund(),
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GuessGameProvider())
          ],
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const _PosterImage(),
              const SizedBox(
                height: 50,
              ),
              _Form(
                movie: movie,
              )
            ],
          )),
        )
      ],
    ));
  }
}

class _Form extends StatelessWidget {
  final String movie;
  const _Form({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final guessGameProvider = Provider.of<GuessGameProvider>(context);
    guessGameProvider.movie = movie;
    return Form(
        key: guessGameProvider.formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => guessGameProvider.guess = value,
                  validator: (value) {
                    return (value != null && value.isNotEmpty)
                        ? null
                        : 'Escribe algo mostruo';
                  },
                  style: const TextStyle(color: AppTheme.secondaryColor),
                ),
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
                                  .withOpacity(0.8)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        onPressed: () {
                          if (!guessGameProvider.isValidForm()) return;
                          guessGameProvider.isFail();
                          print(guessGameProvider.sigma);
                        },
                        child: const Text(
                          'ADIVINAR',
                          style: TextStyle(fontSize: 20),
                        )))
              ],
            )));
  }
}

//* Poster de la pélicula pixelado
class _PosterImage extends StatelessWidget {
  const _PosterImage({
    super.key,
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
            child: const FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(
                  'https://www.themoviedb.org/t/p/w220_and_h330_face/zNKs1T0VZuJiVuhuL5GSCNkGdxf.jpg'),
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
