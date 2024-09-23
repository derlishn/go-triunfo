import 'package:flutter/material.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/utils/helpers/validators.dart';
import 'package:go_triunfo/core/utils/widgets/show_custom_snackbar.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart'; // Importamos el nuevo ViewModel

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

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
              ),
              const SizedBox(height: 20),
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppStrings.passwordHintText,
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) => Validators.passwordValidator(value!),
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
                    await authViewModel.signIn(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (authViewModel.errorMessage != null) {
                      showCustomSnackBar(
                        context,
                        authViewModel.errorMessage!,
                        isError: true,
                      );
                    } else if (authViewModel.user != null) {
                      showCustomSnackBar(
                        context,
                        'Inicio de sesión exitoso',
                        isError: false,
                      );
                      // Navegar a HomeScreen después de éxito
                      replaceAndRemoveUntil(context, HomeScreen());
                    }
                  }
                },
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
