class AuthFields {
  String email = '';
  String? emailError;
  String password = '';
  String? passwordError;
  String confirmPassword = '';
  String? confirmPasswordError;
  String displayName = '';
  String? displayNameError;
  String phoneNumber = ''; // Agregado campo para número de teléfono
  String? phoneNumberError; // Agregado para manejo de errores del número de teléfono
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
    phoneNumber = ''; // Limpiar el número de teléfono
    phoneNumberError = null; // Limpiar el error del número de teléfono
    address = '';
    addressError = null;
    gender = 'no especificado';
    genderError = null;
  }
}
