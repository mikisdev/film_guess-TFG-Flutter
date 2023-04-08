import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tfg_03/services/auth_service.dart';
import 'package:tfg_03/services/firebase_service.dart';
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

    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
        future: getUserData(authService.readUId()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();

          final user = snapshot.data!;
          return _Drawer(
              boxDecoration: boxDecoration,
              user: user['name'],
              authService: authService);
        });
    //child: _Drawer(boxDecoration: boxDecoration, loginFormProvider: loginFormProvider, authService: authService));
  }
}

class _Drawer extends StatefulWidget {
  const _Drawer({
    super.key,
    required this.boxDecoration,
    required this.user,
    required this.authService,
  });

  final BoxDecoration boxDecoration;
  final String user;
  final AuthService authService;

  @override
  State<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: widget.boxDecoration,
        child: Column(
          children: [
            const HeaderLogo(
              height: 170,
              width: 220,
            ),

            //* Usuario
            Text(
              widget.user,
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
                  setState(() {});
                }),

            //*HOME
            _MenuItem(
              text: 'Home',
              onTap: () => Navigator.pushNamed(context, 'home'),
            ),

            //* JUEGOS FAVORITOS
            _MenuItem(
              text: 'Juegos favoritos',
              onTap: () => Navigator.pushNamed(context, 'favorites'),
            ),

            Expanded(child: Container()),

            _MenuItem(
              text: 'Cerrar sesión',
              aligment: Alignment.center,
              color: Colors.black45,
              onTap: () {
                widget.authService.logout();
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
    super.key,
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
