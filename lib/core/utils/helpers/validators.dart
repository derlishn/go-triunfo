import '../../strings/app_strings.dart';

class Validators {
  // Validación de campo vacío
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorEmptyFields; // Usando AppStrings
    }
    return null; // Si todo está bien, no hay errores
  }

  static String? emailValidator(String value) {
    if (value.isEmpty) {
      return AppStrings.errorEmailRequired;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppStrings.errorInvalidEmail;
    }
    return null;
  }

  static String? passwordValidator(String value) {
    if (value.isEmpty) {
      return AppStrings.errorPasswordRequired;
    } else if (value.length < 6) {
      return AppStrings.errorPasswordTooShort; // Usando AppStrings
    }
    return null;
  }

  // Valida el nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorDisplayNameRequired;
    }
    if (value.length < 2) {
      return AppStrings.errorNameTooShort; // Usando AppStrings
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return AppStrings.errorNameInvalid; // Usando AppStrings
    }
    return null;
  }

  // Valida la confirmación de contraseña
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.errorConfirmPasswordRequired; // Usando AppStrings
    }
    if (confirmPassword != password) {
      return AppStrings.errorPasswordsDoNotMatch; // Usando AppStrings
    }
    return null;
  }
}
