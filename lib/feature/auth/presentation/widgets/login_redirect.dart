import 'package:flutter/material.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/login_screen.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        replaceWith(context, const LoginScreen());
      },
      child: Text.rich(
        TextSpan(
          text: AppStrings.alreadyHaveAccountText,
          style:
              Theme.of(context).textTheme.bodyMedium, // Estilo del texto base
          children: [
            TextSpan(
              text: AppStrings.loginNowText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight
                    .bold, // Añadir negrita para destacar "Regístrate Ahora"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
