import 'package:flutter/material.dart';

//* Logo
class HeaderLogo extends StatelessWidget {
  final double width;
  final double height;
  const HeaderLogo({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      width: double.infinity,
      child: Image(
        image: const AssetImage('assets/logo.png'),
        width: width,
        height: height,
      ),
    );
  }
}
