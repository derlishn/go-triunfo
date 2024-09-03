import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/localizations.dart';

class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Text.rich(
        TextSpan(
          text: AppLocalizations.alreadyHaveAccountText,
          children: [
            TextSpan(
              text: AppLocalizations.signInNowText,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
