import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/profile_picture_selector_widget.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = ValueNotifier<String>(AppStrings.maleGenderText);
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? displayNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? _uploadedImageUrl;

  // Validación del correo
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  // Muestra el diálogo de progreso
  Future<void> _showProgressDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  // Actualiza el diálogo de progreso
  Future<void> _updateProgressDialog(
      BuildContext context, String message) async {
    Navigator.pop(context); // Cierra el diálogo actual
    await _showProgressDialog(
        context, message); // Abre uno nuevo con el mensaje actualizado
  }

  // Método para el registro del usuario
  void _signUp(AuthViewModel authViewModel) async {
    setState(() {
      displayNameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    // Validaciones
    if (!_validateForm()) return;

    await _showProgressDialog(context, "Preparando todo...");

    if (_uploadedImageUrl != null) {
      await _updateProgressDialog(context, "Subiendo tu foto...");
    }

    Navigator.pop(context); // Cierra el diálogo

    // Crear el usuario
    await authViewModel.signUp(
      email: emailController.text,
      password: passwordController.text,
      displayName: displayNameController.text,
      gender: genderController.value,
      photoUrl: _uploadedImageUrl, // URL de la imagen subida
    );

    // Validar si hubo errores
    if (authViewModel.errorMessage != null) {
      _handleError(authViewModel.errorMessage!);
    } else {
      await _updateProgressDialog(context, "Creando tu cuenta...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Usuario creado exitosamente!"),
          backgroundColor: Colors.green,
        ),
      );
      _saveUserDataToPreferences(); // Guardar en SharedPreferences
      replaceWith(context, const HomeScreen()); // Navegar al Home
    }
  }

  // Validaciones del formulario
  bool _validateForm() {
    bool isValid = true;

    if (displayNameController.text.isEmpty ||
        displayNameController.text.length < 3) {
      setState(
          () => displayNameError = "El nombre debe tener al menos 3 letras");
      isValid = false;
    }

    if (emailController.text.isEmpty) {
      setState(() => emailError = "El correo no puede estar vacío");
      isValid = false;
    } else if (!_isValidEmail(emailController.text)) {
      setState(() => emailError = "Ingrese un correo válido");
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "La contraseña no puede estar vacía");
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() => confirmPasswordError = "Las contraseñas no coinciden");
      isValid = false;
    }

    return isValid;
  }

  // Manejo de errores
  void _handleError(String errorMessage) {
    setState(() {
      if (errorMessage.contains("email")) {
        emailError = "Correo electrónico no válido o ya en uso.";
      } else if (errorMessage.contains("password")) {
        passwordError = "La contraseña no cumple con los requisitos.";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    });
  }

  // Guardar datos del usuario en SharedPreferences
  void _saveUserDataToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', emailController.text);
    await prefs.setString('user_displayName', displayNameController.text);
    await prefs.setString(
        'user_photoUrl', _uploadedImageUrl ?? ''); // Guardar URL de la imagen
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfilePictureSelectorWidget(
            onImageUploaded: (imageUrl) {
              setState(() {
                _uploadedImageUrl =
                    imageUrl; // Guardar la URL de la imagen subida
              });
            },
          ),
          const SizedBox(height: 40),
          TextField(
            controller: displayNameController,
            decoration: InputDecoration(
              labelText: AppStrings.displayNameHintText,
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              errorText: displayNameError,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: AppStrings.emailHintText,
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              errorText: emailError,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: AppStrings.passwordHintText,
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              errorText: passwordError,
            ),
            obscureText: !isPasswordVisible,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Repite la Contraseña",
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
              errorText: confirmPasswordError,
            ),
            obscureText: !isConfirmPasswordVisible,
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<String>(
            valueListenable: genderController,
            builder: (context, value, child) {
              final theme = Theme.of(context);

              return DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(
                  labelText: AppStrings.genderHintText,
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: AppStrings.maleGenderText,
                    child: Text(
                      AppStrings.maleGenderText,
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal, // Normal weight
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.femaleGenderText,
                    child: Text(
                      AppStrings.femaleGenderText,
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal, // Normal weight
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.otherGenderText,
                    child: Text(
                      AppStrings.otherGenderText,
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal, // Normal weight
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    genderController.value = value;
                  }
                },
              );
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _signUp(authViewModel),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text(AppStrings.registerButtonText),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
