import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/models/models.dart';
import 'package:tfg_03/services/services.dart';
import 'package:tfg_03/themes/app_theme.dart';

//* Lista de actores de las peliculas
class CastingCard extends StatelessWidget {
  final int movieID;

  //* para controlar las peliculas con menos de 10 actores, el maximo que quiero ver
  int _castlenght(int cast) {
    if (cast < 10) {
      return cast;
    } else {
      return 10;
    }
  }

  const CastingCard({super.key, required this.movieID});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieService>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieID),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: double.infinity,
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
                itemCount: _castlenght(cast.length),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, int index) => _CastCard(
                      actor: cast[index],
                    )));
      },
    );
  }
}

//* Carta del actor con su foto y nombre
class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.secondaryColor),
          ),
        ],
      ),
    );
  }
}
