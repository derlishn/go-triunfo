import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/core/utils/localizations.dart';
import 'package:go_triunfo/core/utils/validators.dart';

import '../../../../viewmodels/auth_viewmodel.dart';
import '../../../../viewmodels/password_visibility_notifier.dart';
import '../../../home/home_screen.dart';
import '../forgotPasswordScreen.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authViewModel = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.loginHeader,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          const Text(AppLocalizations.loginSubHeader),
          const SizedBox(height: 40),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: AppLocalizations.emailHintText,
              labelStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: AppLocalizations.passwordHintText,
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  ref.read(passwordVisibilityProvider.notifier).toggleVisibility();
                },
              ),
            ),
            obscureText: !isPasswordVisible,
            validator: Validators.validatePassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: Text(
                AppLocalizations.forgotPasswordText,
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await authViewModel.login(emailController.text, passwordController.text);

                if (authState.errorMessage != null) {
                  // Muestra el error si la autenticación falla
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authState.errorMessage!)),
                  );
                } else {
                  // Si la autenticación es exitosa, navega a la pantalla de home
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              } else {
                // Mostrar Snackbar si hay errores en el formulario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, corrige los errores en el formulario')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text(AppLocalizations.loginButtonText),
          ),
          if (authState.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            ), // Animación de carga
        ],
      ),
    );
  }
}
