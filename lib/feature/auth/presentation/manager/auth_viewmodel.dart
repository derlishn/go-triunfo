import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/use_cases/get_current_user.dart';
import '../../domain/use_cases/sign_in_user.dart';
import '../../domain/use_cases/sign_out_user.dart';
import '../../domain/use_cases/sign_up_user.dart';

class AuthViewModel with ChangeNotifier {
  final SignInUser signInUser;
  final SignUpUser signUpUser;
  final GetCurrentUser getCurrentUser;
  final SignOutUser signOutUser;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  AuthViewModel({
    required this.signInUser,
    required this.signUpUser,
    required this.getCurrentUser,
    required this.signOutUser,
  });

  // Iniciar sesión
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    final result = await signInUser.call(SignInParams(email: email, password: password));
    _handleAuthResult(result);
    _setLoading(false);
  }

  // Registrar usuario
  Future<void> signUp(User user, String password) async {
    _setLoading(true);
    final result = await signUpUser.call(SignUpParams(user: user, password: password));
    _handleAuthResult(result);
    _setLoading(false);
  }

  // Limpiar mensajes de error
  void clearMessages() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mostrar/ocultar contraseña
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Obtener el usuario actual
  Future<void> checkCurrentUser() async {
    _setLoading(true);
    final result = await getCurrentUser.call(NoParams());
    result.fold(
          (failure) {
        _errorMessage = failure.message; // Directamente obtenemos el mensaje del error
        _user = null;
      },
          (user) {
        _user = user;
      },
    );
    _setLoading(false);
    notifyListeners();
  }

  // Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    final result = await signOutUser.call(NoParams());
    result.fold(
          (failure) {
        _errorMessage = failure.message; // Usamos el mensaje del error desde Failure
      },
          (success) {
        _user = null;
      },
    );
    _setLoading(false);
    notifyListeners();
  }

  // Manejar los resultados de autenticación
  void _handleAuthResult(Either<Failure, User> result) {
    result.fold(
          (failure) {
        _errorMessage = failure.message; // Ahora el mensaje de error viene directamente del Failure
      },
          (user) {
        _user = user;
        _errorMessage = null;
      },
    );
    notifyListeners();
  }

  // Manejar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
