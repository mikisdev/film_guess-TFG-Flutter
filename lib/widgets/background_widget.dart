import 'package:flutter/material.dart';
import 'dart:math';

//* Fondo de la aplicación
class BackGround extends StatelessWidget {
  const BackGround({super.key});

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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: boxDecoration,
          ),
          Positioned(top: 500, left: 160, child: _CircleBox())
        ],
      ),
    );
  }
}

class _CircleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadiusDirectional.circular(80),
      gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple, Color.fromARGB(255, 34, 1, 48)]),
    );
    return Transform.rotate(
      angle: -pi / 6,
      child: Container(
        decoration: boxDecoration,
        width: 400,
        height: 400,
      ),
    );
  }
}
