import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/get_current_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_in_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_out_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_up_user.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';

class AuthViewModel extends ChangeNotifier {
  final GetCurrentUser getCurrentUserUseCase;
  final SignInUser signInUserUseCase;
  final SignUpUser signUpUserUseCase;
  final SignOutUser signOutUserUseCase;

  AuthViewModel({
    required this.getCurrentUserUseCase,
    required this.signInUserUseCase,
    required this.signUpUserUseCase,
    required this.signOutUserUseCase,
  });

  // User Data
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Loading State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Password Visibility State
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // Error Messages for Different Operations
  String? _loginErrorMessage;
  String? _signUpErrorMessage;
  String? _generalErrorMessage;

  String? get loginErrorMessage => _loginErrorMessage;
  String? get signUpErrorMessage => _signUpErrorMessage;
  String? get generalErrorMessage => _generalErrorMessage;

  // Success Message
  String? _successMessage;
  String? get successMessage => _successMessage;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    _setLoading(true);
    clearMessages();

    final result = await getCurrentUserUseCase.call();
    result.fold(
          (failure) => _handleError(failure, "getCurrentUser"),
          (user) => _handleSuccessUser(user),
    );

    _setLoading(false);
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);
    clearMessages();

    final result = await signOutUserUseCase.call();
    result.fold(
          (failure) => _handleError(failure, "logout"),
          (_) {
        _currentUser = null;
        replaceWith(context, const WelcomeScreen());
        _successMessage = AppStrings.successLoggedOut;
      },
    );

    _setLoading(false);
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
    String? address,
    required String gender,
  }) async {
    _setLoading(true);
    clearMessages();

    final user = User(
      uid: '', // El UID será generado por Firebase
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
      address: address,
      createdAt: DateTime.now(),
      role: 'client',
      gender: gender,
      orders: 0, // Órdenes iniciales en 0
    );

    final result = await signUpUserUseCase.call(user, password);

    result.fold(
          (failure) {
        _handleError(failure, "signUp");
      },
          (registeredUser) {
        _handleSuccessUser(registeredUser);
        _successMessage = AppStrings.successUserCreated;
      },
    );

    _setLoading(false);
  }


  // Login User
  Future<void> login(String email, String password) async {
    _setLoading(true);
    clearMessages();

    final result = await signInUserUseCase.call(SignInParams(email: email, password: password));

    result.fold(
          (failure) => _handleError(failure, "login"),
          (user) => _handleSuccessUser(user),
    );

    _setLoading(false);
  }

  // Clear Error and Success Messages
  void clearMessages() {
    _loginErrorMessage = null;
    _signUpErrorMessage = null;
    _generalErrorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Helper: Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper: Handle Success for User Retrieval
  void _handleSuccessUser(User? user) {
    if (user != null) {
      _currentUser = user;
      _successMessage = AppStrings.operationSuccess;
      clearMessages();
    } else {
      _generalErrorMessage = AppStrings.errorGeneral;
    }
    notifyListeners();
  }

  void _handleError(Failure failure, String operationType) {
    String message;

    if (failure is NetworkFailure) {
      message = failure.message;  // Asegúrate de que el mensaje se propaga
    } else if (failure is ServerFailure) {
      message = failure.message;  // Accede al mensaje de ServerFailure
    } else {
      message = 'Ocurrió un error desconocido';
    }

    // Dependiendo de la operación, asigna el mensaje correcto
    switch (operationType) {
      case "login":
        _loginErrorMessage = message;
        break;
      case "signUp":
        _signUpErrorMessage = message;
        break;
      default:
        _generalErrorMessage = message;
        break;
    }

    notifyListeners();
  }
}
