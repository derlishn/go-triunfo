import '../../resources/strings.dart';

class Validators {
  // Validación de campo vacío
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
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
      return 'La contraseña debe tener 6 characters o más';
    }
    return null;
  }

  // Valida el nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre no puede estar vacío';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solo debe contener letras y espacios';
    }
    return null;
  }

  // Valida la confirmación de contraseña
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Debes confirmar tu contraseña';
    }
    if (confirmPassword != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
