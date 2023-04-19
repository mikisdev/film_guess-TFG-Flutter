import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //* Color primario de la app
  static const Color primaryColor = Color.fromARGB(255, 104, 58, 183);

  //* Color secundario
  static const Color secondaryColor = Color.fromARGB(255, 237, 222, 240);

  //* tema modo claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      //* Tipografia
      textTheme: GoogleFonts.lilitaOneTextTheme().copyWith(),

      //* AppBar
      appBarTheme: const AppBarTheme(
          color: primaryColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: secondaryColor)),

      //* TextButton
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      )),

      //* Boton
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0)),

      //*Formularios
      inputDecorationTheme: const InputDecorationTheme(
        //Todo: poner color para el hint
        hintStyle: TextStyle(color: secondaryColor),

        //Todo: poner color para el label
        labelStyle: TextStyle(color: secondaryColor),
        //* Color del label
        floatingLabelStyle: TextStyle(color: primaryColor),

        //* Color de los iconos
        suffixIconColor: secondaryColor,

        //* Color del borde
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),

        //* forma y color del borde al seleccionarlo
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
        ),

        //* forma del borde sin seleccionarlo
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
      ));
}
