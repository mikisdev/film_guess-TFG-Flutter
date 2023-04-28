import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tfg_03/routes/routes.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/providers/providers.dart';
import 'package:tfg_03/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthService()),
              ChangeNotifierProvider(create: (_) => LoginFormProvider()),
              ChangeNotifierProvider(create: (_) => FireBaseService()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(create: (_) => MovieService()),
              ChangeNotifierProvider(create: (_) => FavoriteMovieService()),
            ],
            child: MyApp(user: snapshot.data),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthService()),
              ChangeNotifierProvider(create: (_) => LoginFormProvider()),
              ChangeNotifierProvider(create: (_) => FireBaseService()),
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(create: (_) => MovieService()),
              ChangeNotifierProvider(create: (_) => FavoriteMovieService()),
            ],
            child: const MyApp(),
          );
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFG',
      //* ruta inicial
      initialRoute: user != null ? 'home' : Routes.initialRoute,
      //* lista de rutas
      routes: Routes.routes,
      //* tema de la aplicación
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: NotificationsService.messengerKey,
    );
  }
}
