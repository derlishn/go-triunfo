import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/core/utils/helpers/validators.dart';
import 'package:go_triunfo/core/utils/widgets/showCustomSnackBar.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override

  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _selectedGender; // Variable para el género seleccionado

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.registerHeader,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              const Text(AppStrings.registerSubHeader),
              const SizedBox(height: 40),
              // Display Name
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.displayNameHintText,
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : AppStrings.errorDisplayNameRequired,
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: AppStrings.emailHintText,
                  prefixIcon: Icon(Icons.email),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.emailValidator(value!),
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: !authViewModel.isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppStrings.passwordHintText,
                  prefixIcon: const Icon(Icons.lock),
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
              const SizedBox(height: 20),
              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: AppStrings.confirmPasswordHintText,
                  prefixIcon: Icon(Icons.lock),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return AppStrings.errorPasswordsDoNotMatch;
                  }
                  return null;
                },
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: AppStrings.phoneHintText,
                  prefixIcon: Icon(Icons.phone),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : AppStrings.errorPhoneRequired,
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: AppStrings.addressHintText,
                  prefixIcon: Icon(Icons.location_on),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.streetAddress,
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : AppStrings.errorAddressRequired,
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Gender (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: AppStrings.gendertitle,
                  prefixIcon: Icon(Icons.person_outline),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                items: [AppStrings.maleGenderText, AppStrings.femaleGenderText, AppStrings.otherGenderText]
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                  authViewModel.clearMessages();
                },
                validator: (value) => value == null
                    ? AppStrings.errorGenderRequired
                    : null,
              ),
              const SizedBox(height: 20),
              // Register Button
              // Register Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Limpia los mensajes previos
                    authViewModel.clearMessages();

                    // Llama al método de registro
                    await authViewModel.register(
                      email: _emailController.text,
                      password: _passwordController.text,
                      displayName: _displayNameController.text,
                      phoneNumber: _phoneNumberController.text,
                      address: _addressController.text,
                      gender: _selectedGender!,
                    );

                    if (authViewModel.signUpErrorMessage != null) {
                      // Asegúrate de mostrar el mensaje de error con `isError: true`.
                      showCustomSnackBar(
                        context,
                        authViewModel.signUpErrorMessage!,
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
                    : const Text(AppStrings.registerButtonText),
              )
            ],
          ),
        ),
      ),
    );
  }
}
