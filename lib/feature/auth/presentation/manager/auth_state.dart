import 'package:go_triunfo/feature/auth/domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage; // Mensaje de éxito agregado
  final User? user;

  AuthState({
    required this.isLoading,
    required this.errorMessage,
    this.successMessage, // Inicializamos
    required this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      errorMessage: null,
      successMessage: null, // Iniciamos en null
      user: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage, // Manejamos éxito
      user: user ?? this.user,
    );
  }
}
