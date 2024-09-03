import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_triunfo/data/providers/auth_providers.dart';
import 'package:go_triunfo/domain/models/user_model.dart';
import 'package:go_triunfo/domain/usecases/login_usecase.dart';
import 'package:go_triunfo/domain/usecases/register_usecase.dart';
import 'package:go_triunfo/domain/usecases/logout_usecase.dart';
import 'package:go_triunfo/domain/usecases/google_sign_in_usecase.dart';


// ViewModel que maneja el estado de autenticación
class AuthViewModel extends StateNotifier<UserModel?> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;

  AuthViewModel(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._googleSignInUseCase,
      ) : super(null);

  // Método para iniciar sesión con email y contraseña
  Future<void> login(String email, String password) async {
    state = await _loginUseCase.execute(email, password);
  }

  // Método para registrar un nuevo usuario con email y contraseña
  Future<void> register(String email, String password) async {
    state = await _registerUseCase.execute(email, password);
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _logoutUseCase.execute();
    state = null;
  }

  // Método para iniciar sesión con Google
  Future<void> signInWithGoogle() async {
    state = await _googleSignInUseCase.execute();
  }

  // Método para escuchar cambios en el estado de autenticación
  Stream<UserModel?> authStateChanges() {
    return _googleSignInUseCase.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(id: user.uid, email: user.email!, displayName: user.displayName);
    });
  }
}

// Proveedor del ViewModel de autenticación
final authProvider = StateNotifierProvider<AuthViewModel, UserModel?>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final registerUseCase = ref.read(registerUseCaseProvider);
  final logoutUseCase = ref.read(logoutUseCaseProvider);
  final googleSignInUseCase = ref.read(googleSignInUseCaseProvider);

  return AuthViewModel(loginUseCase, registerUseCase, logoutUseCase, googleSignInUseCase);
});
