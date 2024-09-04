import 'package:flutter/material.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/forgot_password_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.loginHeader,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
          ),
          const SizedBox(height: 8),
          const Text(AppStrings.loginSubHeader),
          const SizedBox(height: 40),
          const TextField(
            decoration: InputDecoration(
              labelText: AppStrings.emailHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: AppStrings.passwordHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.visibility_off), // Icono predeterminado
            ),
            obscureText: true, // Predeterminado
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                navigateTo(context, const ForgotPasswordScreen());
              },
              child: Text(
                AppStrings.forgotPasswordText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Acción del botón de inicio de sesión
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text(AppStrings.loginButtonText),
          ),
        ],
      ),
    );
  }
}
