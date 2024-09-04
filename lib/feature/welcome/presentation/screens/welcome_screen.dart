import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/welcome/presentation/widgets/welcome_auth_buttons.dart';
import 'package:go_triunfo/feature/welcome/presentation/widgets/welcome_background.dart';
import 'package:go_triunfo/feature/welcome/presentation/widgets/welcome_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          WelcomeBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeLogo(),
                    SizedBox(height: 100),
                    AuthButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
