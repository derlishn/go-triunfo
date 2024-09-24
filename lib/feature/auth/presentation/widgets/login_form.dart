import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/core/utils/widgets/show_custom_snackbar.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';

import '../manager/auth_viewmodel.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            // Email field
            TextField(
              onChanged: (value) {
                authViewModel.fields.email = value;
                authViewModel.updateFieldErrors(); // Actualizar errores en tiempo real
              },
              decoration: InputDecoration(
                labelText: AppStrings.emailHintText,
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.emailError, // Mostrar el error del email
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              onChanged: (value) {
                authViewModel.fields.password = value;
                authViewModel.updateFieldErrors(); // Actualizar errores en tiempo real
              },
              obscureText: !authViewModel.fields.isPasswordVisible,
              decoration: InputDecoration(
                labelText: AppStrings.passwordHintText,
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                errorText: authViewModel.fields.passwordError, // Mostrar el error de la contraseña
                suffixIcon: IconButton(
                  icon: Icon(
                    authViewModel.fields.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: authViewModel.togglePasswordVisibility,
                ),
              ),
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
            // Login button
            ElevatedButton(
              onPressed: authViewModel.isLoading
                  ? null
                  : () async {
                await authViewModel.signIn();

                if (authViewModel.errorMessage != null) {
                  showCustomSnackBar(
                    context,
                    authViewModel.errorMessage!,
                    isError: true,
                  );
                } else if (authViewModel.currentUser != null) {
                  showCustomSnackBar(
                    context,
                    'Inicio de sesión exitoso',
                    isError: false,
                  );
                  // Navegar a HomeScreen después de éxito
                  replaceAndRemoveUntil(context, HomeScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: authViewModel.isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(AppStrings.loginButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
