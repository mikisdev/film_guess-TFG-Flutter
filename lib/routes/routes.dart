import 'package:flutter/material.dart';
import 'package:tfg_03/screens/screens.dart';

class Routes {
  //* ruta inicial de la app
  static const initialRoute = 'login';

  //* Lista de rutas de la aplicación
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'sign_up': (BuildContext context) => const SignUpScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'favorites': (BuildContext context) => const FavoritesScreen(),
    'details': (BuildContext context) => const DetailsScreen(),
    'profile': (BuildContext context) => const ProfileScreen(),
    'game': (BuildContext context) => const GameScreen(),
  };
}
