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
                decoration: InputDecoration(
                  labelText: AppStrings.displayNameHintText,
                  prefixIcon: const Icon(Icons.person),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Please enter your name',
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppStrings.emailHintText,
                  prefixIcon: const Icon(Icons.email),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: AppStrings.phoneHintText,
                  prefixIcon: const Icon(Icons.phone),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Please enter your phone number',
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: AppStrings.addressHintText,
                  prefixIcon: const Icon(Icons.location_on),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.streetAddress,
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Please enter your address',
                onChanged: (value) => authViewModel.clearMessages(),
              ),
              const SizedBox(height: 20),
              // Gender (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(Icons.person_outline),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
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
                    ? 'Please select your gender'
                    : null,
              ),
              const SizedBox(height: 20),
              // Register Button
              // Register Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authViewModel.register(
                      email: _emailController.text,
                      password: _passwordController.text,
                      displayName: _displayNameController.text,
                      phoneNumber: _phoneNumberController.text,
                      address: _addressController.text,
                      gender: _selectedGender!,
                    );
                    if (authViewModel.signUpErrorMessage != null) {
                      showCustomSnackBar(
                          context, authViewModel.signUpErrorMessage!);
                    } else if (authViewModel.successMessage != null) {
                      // Mostrar SnackBar con "Usuario creado"
                      showCustomSnackBar(context, 'Usuario creado con éxito');
                      // Navegar a HomeScreen
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
