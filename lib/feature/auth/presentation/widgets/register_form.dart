import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_triunfo/core/utils/helpers/phone_number_input_formatter.dart';
import 'package:go_triunfo/feature/auth/domain/entities/address.dart';
import 'package:go_triunfo/feature/auth/domain/entities/enums.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/validators.dart';
import 'package:go_triunfo/core/utils/widgets/show_custom_snackbar.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';



class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Gender? _selectedGender;

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
                decoration: InputDecoration(
                  labelText: AppStrings.phoneHintText,
                  prefixIcon: const Icon(Icons.phone),
                  labelStyle: const TextStyle(fontSize: 16),
                  filled: true, // Añade un fondo detrás del campo
                  fillColor: Colors.grey[200], // Color de fondo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Bordes redondeados
                    borderSide: BorderSide.none, // Sin borde visible (solo sombra)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue, width: 2), // Borde cuando está enfocado
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 2), // Borde en caso de error
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Espacio interno
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 9, // Limita a 9 caracteres incluyendo los guiones
                style: const TextStyle(
                  fontSize: 18, // Tamaño de fuente más grande
                  letterSpacing: 2.0, // Espaciado entre caracteres
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Solo permite números
                  PhoneNumberInputFormatter(), // Formateador personalizado
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.errorPhoneRequired;
                  } else if (value.length != 9) {
                    return 'Debe ingresar 8 números';
                  }
                  return null;
                },
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
              DropdownButtonFormField<Gender>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: AppStrings.gendertitle,
                  prefixIcon: Icon(Icons.person_outline),
                  labelStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(),
                ),
                items: Gender.values
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender == Gender.male
                        ? AppStrings.maleGenderText
                        : gender == Gender.female
                        ? AppStrings.femaleGenderText
                        : AppStrings.otherGenderText,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    authViewModel.clearMessages();
                    Address address = Address(location: _addressController.text);

                    User user = User(
                      uid: '',
                      email: _emailController.text,
                      displayName: _displayNameController.text,
                      phoneNumber: _phoneNumberController.text,
                      address: address,
                      createdAt: DateTime.now(),
                      gender: _selectedGender!,
                    );

                    await authViewModel.signUp(
                      user,
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
                        'Registro exitoso',
                        isError: false,
                      );
                      replaceAndRemoveUntil(context, HomeScreen());
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


class _PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 8) return oldValue;

    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');

    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 3 && newText.length > 4) {
        buffer.write('-');
      }
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
