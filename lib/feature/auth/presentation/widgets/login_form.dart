import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/core/utils/helpers/validators.dart';
import 'package:go_triunfo/core/utils/widgets/showCustomSnackBar.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: AppStrings.emailHintText,
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.emailValidator(value!),
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: !authViewModel.isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppStrings.passwordHintText,
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authViewModel.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: authViewModel.togglePasswordVisibility,
                  ),
                ),
                validator: (value) => Validators.passwordValidator(value!),
                onChanged: (value) => authViewModel.clearMessages(),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authViewModel.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (authViewModel.loginErrorMessage != null) {
                      showCustomSnackBar(
                        context,
                        authViewModel.loginErrorMessage!,
                        isError: true,
                      );
                    } else if (authViewModel.successMessage != null) {
                      showCustomSnackBar(
                        context,
                        authViewModel.successMessage!,
                        isError: false, // Verde para mensajes de éxito
                      );
                      // Navegar a HomeScreen después de éxito
                      replaceAndRemoveUntil(context, const HomeScreen());
                    }
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
      ),
    );
  }
}
