import 'package:flutter/material.dart';
import 'package:tfg_03/models/models.dart';
import 'package:tfg_03/themes/app_theme.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
        body: Stack(
      children: [
        const _Backgorund(),
        Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            _PosterImage(
              poster: movie.fullPosterImage,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              '¡¡VICTORIA!!',
              style: TextStyle(color: AppTheme.primaryColor, fontSize: 50),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(8),
                  shadowColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 87, 43, 180).withOpacity(0.8),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'game'),
                child: const Text(
                  '¿Echamos otra partida?',
                  style: TextStyle(fontSize: 25),
                ))
          ],
        )
      ],
    ));
  }
}

class _PosterImage extends StatelessWidget {
  final String poster;
  const _PosterImage({
    super.key,
    required this.poster,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height * 0.5,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(poster))),
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
