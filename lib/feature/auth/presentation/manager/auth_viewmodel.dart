import 'package:flutter/foundation.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'; // Importar el paquete

import '../../data/models/user_dto.dart';
import '../../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;

  UserDTO? _currentUser;

  // Campos de entrada y sus errores
  String _email = '';
  String? _emailError;
  String _password = '';
  String? _passwordError;
  String _confirmPassword = '';
  String? _confirmPasswordError;
  String _displayName = '';
  String? _displayNameError;
  PhoneNumber? _phoneNumber;
  String? _phoneNumberError;
  String _address = '';
  String? _addressError;
  String _gender = 'no especificado';
  String? _genderError;

  bool _isPasswordVisible = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserDTO? get currentUser => _currentUser;

  String get email => _email;
  String? get emailError => _emailError;
  String get password => _password;
  String? get passwordError => _passwordError;
  String get confirmPassword => _confirmPassword;
  String? get confirmPasswordError => _confirmPasswordError;
  String get displayName => _displayName;
  String? get displayNameError => _displayNameError;
  String? get phoneNumber => _phoneNumber?.phoneNumber;
  String? get phoneNumberError => _phoneNumberError;
  String get address => _address;
  String? get addressError => _addressError;
  String get gender => _gender;
  String? get genderError => _genderError;
  bool get isPasswordVisible => _isPasswordVisible;

  void setEmail(String value) {
    _email = value.trim();
    _emailError = _validateEmail(_email);
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = _validatePassword(_password);
    _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    notifyListeners();
  }

  void setDisplayName(String value) {
    _displayName = value.trim();
    _displayNameError = _validateDisplayName(_displayName);
    notifyListeners();
  }

  void setPhoneNumber(PhoneNumber number) {
    _phoneNumber = number;
    _phoneNumberError = _validatePhoneNumber(number);
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value.trim();
    _addressError = _validateAddress(_address);
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value ?? 'no especificado';
    _genderError = _validateGender(_gender);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateDisplayName(String value) {
    if (value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  String? _validatePhoneNumber(PhoneNumber number) {
    if (number.phoneNumber == null || number.phoneNumber!.isEmpty) {
      return 'El número de teléfono es obligatorio';
    }
    return null;
  }

  String? _validateAddress(String value) {
    if (value.isEmpty) {
      return 'La dirección es obligatoria';
    }
    return null;
  }

  String? _validateGender(String value) {
    if (value == 'no especificado') {
      return 'Selecciona un género';
    }
    return null;
  }

  bool get isLoginFormValid {
    return _emailError == null && _passwordError == null;
  }

  bool get isSignUpFormValid {
    return _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _displayNameError == null &&
        _phoneNumberError == null &&
        _addressError == null &&
        _genderError == null;
  }

  Future<void> signIn() async {
    _emailError = _validateEmail(_email);
    _passwordError = _validatePassword(_password);

    if (!isLoginFormValid) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.signIn(_email, _password);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp() async {

    _emailError = _validateEmail(_email);
    _passwordError = _validatePassword(_password);
    _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    _displayNameError = _validateDisplayName(_displayName);
    _phoneNumberError = _validatePhoneNumber(_phoneNumber ?? PhoneNumber(phoneNumber: ''));
    _addressError = _validateAddress(_address);
    _genderError = _validateGender(_gender);

    if (!isSignUpFormValid) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserDTO userDTO = UserDTO(
        uid: '',
        email: _email,
        displayName: _displayName,
        phoneNumber: _phoneNumber?.phoneNumber ?? '',
        address: _address,
        photoUrl: null,
        createdAt: DateTime.now(),
        role: 'cliente',
        gender: _gender,
        orders: 0,
      );

      _currentUser = await _authRepository.signUp(userDTO, _password);
      clearForm();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      clearForm();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    _email = '';
    _emailError = null;
    _password = '';
    _passwordError = null;
    _confirmPassword = '';
    _confirmPasswordError = null;
    _displayName = '';
    _displayNameError = null;
    _phoneNumber = null;
    _phoneNumberError = null;
    _address = '';
    _addressError = null;
    _gender = 'no especificado';
    _genderError = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
