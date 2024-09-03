import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/localizations.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: FilledButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text(AppLocalizations.loginButtonText)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text(AppLocalizations.registerButtonText)),
            ),
          ),
        ),
      ],
    );
  }
}
