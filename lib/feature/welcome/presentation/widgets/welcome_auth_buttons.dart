import 'package:flutter/material.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/login_screen.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/register_screen.dart';

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
              navigateTo(context, const LoginScreen());
            },
            style: FilledButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text(AppStrings.loginButtonText)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: OutlinedButton(
            onPressed: () {
              navigateTo(context, const RegisterScreen());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text(AppStrings.registerButtonText)),
            ),
          ),
        ),
      ],
    );
  }
}
