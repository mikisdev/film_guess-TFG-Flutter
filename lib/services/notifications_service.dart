import 'package:flutter/material.dart';
import 'package:tfg_03/themes/app_theme.dart';

//* Mensajes emergentes en la aplicación
class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
        backgroundColor: color,
        elevation: 10,
        content: Text(
          _message(message),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.secondaryColor,
            fontSize: 20,
          ),
        ));

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  //* Mensajes de error para login y registro
  static String _message(String message) {
    switch (message) {
      case 'email-already-exists':
        return 'La dirección de correo electrónico ya está en uso';
      case 'user-not-found':
        return 'El correo electronico no existe';
      case 'wrong-password':
        return 'El correo y contraseña no coinciden';
      case 'user-disabled':
        return 'Esta cuenta ha sido bloqueada';
    }

    return message;
  }
}
