import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (confirmPassword != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  static String? validateDisplayName(String value) {
    if (value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  static String? validatePhoneNumber(PhoneNumber number) {
    if (number.phoneNumber == null || number.phoneNumber!.isEmpty) {
      return 'El número de teléfono es obligatorio';
    }
    return null;
  }

  static String? validateAddress(String value) {
    if (value.isEmpty) {
      return 'La dirección es obligatoria';
    }
    return null;
  }

  static String? validateGender(String value) {
    if (value == 'no especificado') {
      return 'Selecciona un género';
    }
    return null;
  }
}
