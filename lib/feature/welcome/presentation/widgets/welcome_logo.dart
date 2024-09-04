import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_name_orange_white.png',
      height: 300,
    );
  }
}
