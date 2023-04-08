import 'package:flutter/material.dart';
import 'package:tfg_03/themes/app_theme.dart';
import 'package:tfg_03/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerMenu(),
        appBar: AppBar(
          title: const Text(
            'Game Guess',
            style: TextStyle(color: AppTheme.secondaryColor),
          ),
        ),
        body: const Stack(
          children: [
            BackGround(),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CardSwiper()
              ],
            )
          ],
        ));
  }
}
