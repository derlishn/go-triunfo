import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_triunfo/domain/models/user_model.dart';
import 'package:go_triunfo/domain/usecases/login_usecase.dart';
import 'package:go_triunfo/domain/usecases/register_usecase.dart';
import 'package:go_triunfo/domain/usecases/logout_usecase.dart';
import 'package:go_triunfo/domain/usecases/google_sign_in_usecase.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';
import 'package:go_triunfo/presentation/viewmodels/auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final UserManagementUseCase _userManagementUseCase;

  AuthViewModel(
      this._loginUseCase,
      this._registerUseCase,
      this._logoutUseCase,
      this._googleSignInUseCase,
      this._userManagementUseCase,
      ) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _loginUseCase.execute(email, password);
      if (user != null) {
        final userModel = await _userManagementUseCase.getUserById(user.uid);
        state = state.copyWith(user: userModel, isLoading: false);
      } else {
        state = state.copyWith(errorMessage: "Usuario no encontrado.", isLoading: false);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        errorMessage: _mapFirebaseAuthErrorToMessage(e.code),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error inesperado. Inténtalo de nuevo.',
        isLoading: false,
      );
    }
  }

  Future<void> register(String email, String password, String displayName, String gender) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _registerUseCase.execute(email, password, displayName, gender);
      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: displayName,
          role: 'usuario',
          isActive: true,
          createdAt: DateTime.now(),
          gender: gender,
        );
        await _userManagementUseCase.createUser(userModel);
        state = state.copyWith(user: userModel, isLoading: false);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        errorMessage: _mapFirebaseAuthErrorToMessage(e.code),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error inesperado. Inténtalo de nuevo.',
        isLoading: false,
      );
    }
  }

  Future<void> signOut() async {
    await _logoutUseCase.execute();
    state = AuthState();
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _googleSignInUseCase.execute();
      if (user != null) {
        final userModel = await _userManagementUseCase.getUserById(user.uid);
        state = state.copyWith(user: userModel, isLoading: false);
      } else {
        state = state.copyWith(errorMessage: "Usuario no encontrado.", isLoading: false);
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al iniciar sesión con Google.',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error inesperado. Inténtalo de nuevo.',
        isLoading: false,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(errorMessage: 'Error al enviar el correo de recuperación.');
    }
  }

  String _mapFirebaseAuthErrorToMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuario no encontrado.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está en uso.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      default:
        return 'Ha ocurrido un error. Inténtalo de nuevo.';
    }
  }
}
