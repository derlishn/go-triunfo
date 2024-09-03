import 'package:flutter/material.dart';
import 'widgets/welcome_background.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/auth_buttons.dart';

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
