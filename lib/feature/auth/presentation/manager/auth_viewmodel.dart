import 'dart:convert';  // Import necesario para la conversión de JSON
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  set currentUser(UserDTO? user) {
    _currentUser = user;
    notifyListeners(); // Notificar a los oyentes que el valor ha cambiado
  }

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

  // Guardar el objeto UserDTO en SharedPreferences como JSON
  Future<void> saveUserSession(UserDTO user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());  // Convertir UserDTO a JSON
    print('Guardando usuario en SharedPreferences: $userJson'); // Debug
    await prefs.setString('currentUser', userJson);
  }

  Future<UserDTO?> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('currentUser');
    print('Cargando usuario de SharedPreferences: $userJson'); // Debug

    if (userJson != null) {
      final userMap = jsonDecode(userJson);  // Convertir JSON a Map
      final user = UserDTO.fromJson(userMap);  // Convertir Map a UserDTO
      _currentUser = user;  // Establecer el usuario actual
      notifyListeners();  // Notificar a los oyentes
      print('Usuario después de cargar de SharedPreferences: $user'); // Debug
      return user;
    }

    return null;
  }



  // Eliminar los datos de la sesión en SharedPreferences
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
  }

  Future<void> signIn() async {
    _formSubmitted = true;
    updateFieldErrors();
    if (!_validateFields()) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.signIn(fields.email, fields.password);
      print('Usuario autenticado: ${_currentUser!.toJson()}'); // Debug
      await saveUserSession(_currentUser!);  // Guardar la sesión del usuario en SharedPreferences
      _isLoading = false;
      notifyListeners(); // Notifica el éxito para redirigir a la pantalla de inicio
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> signUp() async {
    _formSubmitted = true;
    updateFieldErrors();
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
      await saveUserSession(_currentUser!);  // Asegúrate de guardar la sesión del usuario
      fields.clearFields();
      _formSubmitted = false;
    });
  }

  Future<void> listenToUserUpdates(String uid) async {
    _authRepository.listenToUserUpdates(uid).listen((updatedUser) async {
      _currentUser = updatedUser;
      await saveUserSession(updatedUser);  // Actualizar el usuario en SharedPreferences
      notifyListeners();
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

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signOut();  // Llamada a Firebase Auth para cerrar sesión
      _currentUser = null;  // Limpiar el usuario actual
      await clearUserSession();  // Limpiar la sesión de SharedPreferences
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserDTO updatedUser) async {
    try {
      // Actualiza los datos en Firebase
      await _authRepository.updateUser(updatedUser);

      // Actualiza el usuario en la aplicación y guarda en SharedPreferences
      _currentUser = updatedUser;
      await saveUserSession(_currentUser!);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error actualizando el perfil: ${e.toString()}";
      notifyListeners();
    }
  }
}
