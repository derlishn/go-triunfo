import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthFields {
  String email = '';
  String? emailError;
  String password = '';
  String? passwordError;
  String confirmPassword = '';
  String? confirmPasswordError;
  String displayName = '';
  String? displayNameError;
  PhoneNumber? phoneNumber;
  String? phoneNumberError;
  String address = '';
  String? addressError;
  String gender = 'no especificado';
  String? genderError;

  bool isPasswordVisible = false;

  // Método para limpiar los campos
  void clearFields() {
    email = '';
    emailError = null;
    password = '';
    passwordError = null;
    confirmPassword = '';
    confirmPasswordError = null;
    displayName = '';
    displayNameError = null;
    phoneNumber = null;
    phoneNumberError = null;
    address = '';
    addressError = null;
    gender = 'no especificado';
    genderError = null;
  }
}
