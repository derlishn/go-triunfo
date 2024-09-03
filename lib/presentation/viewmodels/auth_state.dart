import '../../domain/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final String? errorMessage;
  final bool isLoading;
  final bool isPasswordVisible;

  AuthState({this.user, this.errorMessage, this.isLoading = false, this.isPasswordVisible = false});

  AuthState copyWith({UserModel? user, String? errorMessage, bool? isLoading, bool? isPasswordVisible}) {
    return AuthState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
