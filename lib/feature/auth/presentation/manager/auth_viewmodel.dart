import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../data/models/auth_fields.dart';
import '../../data/models/user_dto.dart';
import '../../repository/auth_repository.dart';
import 'auth_validator.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthFields fields = AuthFields();

  bool _isLoading = false;
  String? _errorMessage;
  UserDTO? _currentUser;
  bool _formSubmitted = false;  // Controla si el formulario fue enviado

  // Constructor que asegura la inicialización de _authRepository
  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();  // Asigna un valor por defecto si no se proporciona

  // Getters para la UI
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserDTO? get currentUser => _currentUser;
  bool get isPasswordVisible => fields.isPasswordVisible;

  // Actualización de los errores si el formulario ya fue enviado
  void updateFieldErrors() {
    if (_formSubmitted) {
      fields.emailError = AuthValidator.validateEmail(fields.email);
      fields.passwordError = AuthValidator.validatePassword(fields.password);
    }
  }

  // Validar solo cuando el formulario ha sido enviado
  bool _validateFields() {
    updateFieldErrors();
    return fields.emailError == null && fields.passwordError == null;
  }

  Future<void> signIn() async {
    _formSubmitted = true;  // Marca el formulario como enviado
    updateFieldErrors();    // Actualiza los errores
    if (!_validateFields()) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.signIn(fields.email, fields.password);
      _isLoading = false;
      notifyListeners(); // Notifica el éxito para redirigir a la pantalla de inicio
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners(); // Notifica el error para mostrar el mensaje
    }
  }

  Future<void> signUp() async {
    _formSubmitted = true;  // Marca el formulario como enviado
    updateFieldErrors();    // Actualiza los errores
    if (!_validateFields()) {
      notifyListeners();
      return;
    }

    await _handleAuth(() async {
      UserDTO userDTO = UserDTO(
        uid: '',
        email: fields.email,
        displayName: fields.displayName,
        phoneNumber: fields.phoneNumber?.phoneNumber ?? '',
        address: fields.address,
        createdAt: DateTime.now(),
        role: 'cliente',
        gender: fields.gender,
        orders: 0,
      );
      _currentUser = await _authRepository.signUp(userDTO, fields.password);
      fields.clearFields();
      _formSubmitted = false;  // Restablece el estado del formulario
    });
  }

  Future<void> _handleAuth(Future<void> Function() authFunction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authFunction();  // Ejecuta la función de autenticación
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    fields.isPasswordVisible = !fields.isPasswordVisible;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}



