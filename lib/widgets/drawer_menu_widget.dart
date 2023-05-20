import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/services/firebase/auth_service.dart';
import 'package:tfg_03/services/firebase/firebase_service.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/header_logo.dart';

//* Drawer menu
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    //* Color del fondo
    const boxDecoration = BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 28, 29, 59),
        Color.fromARGB(255, 18, 20, 30)
      ],
    ));

    final authService = Provider.of<AuthService>(context);

    return FutureBuilder(
        future: getUserData(authService.readUId()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();

          final user = snapshot.data!;
          return _Drawer(
              boxDecoration: boxDecoration,
              user: user['email'],
              authService: authService);
        });
  }
}

class _Drawer extends StatelessWidget {
  final BoxDecoration boxDecoration;
  final String user;
  final AuthService authService;
  const _Drawer(
      {super.key,
      required this.boxDecoration,
      required this.user,
      required this.authService});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: boxDecoration,
        child: Column(
          children: [
            const HeaderLogo(
              height: 170,
              width: 220,
            ),
            const SizedBox(
              height: 10,
            ),
            //* Usuario
            Text(
              user,
              style:
                  const TextStyle(color: AppTheme.secondaryColor, fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),

            //* PERFIL
            _MenuItem(
                text: 'Perfil',
                onTap: () async {
                  await Navigator.pushNamed(context, 'profile');
                }),

            //* JUEGOS FAVORITOS
            _MenuItem(
              text: 'Peliculas favoritas',
              onTap: () => Navigator.pushNamed(context, 'favorites'),
            ),

            Expanded(child: Container()),

            _MenuItem(
              text: 'Cerrar sesión',
              aligment: Alignment.center,
              color: Colors.black45,
              onTap: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
            )
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String text;
  final Function() onTap;
  final AlignmentGeometry? aligment;
  final Color? color;
  const _MenuItem({
    required this.text,
    required this.onTap,
    this.aligment,
    this.color = Colors.black12,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: aligment,
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        color: color,
        child: Text(
          text,
          style: const TextStyle(color: AppTheme.secondaryColor),
        ),
      ),
    );
  }
}
