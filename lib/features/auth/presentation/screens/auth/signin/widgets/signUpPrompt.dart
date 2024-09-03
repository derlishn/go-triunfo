import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/localizations.dart';
import '../../signup/register_screen.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      child: Text.rich(
        TextSpan(
          text: AppLocalizations.dontHaveAccountText,
          style: Theme.of(context).textTheme.bodyMedium, // Estilo del texto base
          children: [
            TextSpan(
              text: AppLocalizations.registerNowText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold, // Añadir negrita para destacar "Regístrate Ahora"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
