import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tfg_03/services/services.dart';
import 'firebase_options.dart';

import 'package:tfg_03/routes/routes.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => FireBaseService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFG',
      //* ruta inicial
      initialRoute: Routes.initialRoute,
      //* lista de rutas
      routes: Routes.routes,
      //* tema de la aplicación
      theme: AppTheme.lightTheme,
    );
  }
}
