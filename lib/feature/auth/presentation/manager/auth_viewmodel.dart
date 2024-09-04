import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/data/models/user_model.dart';
import 'package:go_triunfo/feature/auth/data/data_sources/firebase_auth_datasource.dart';
import 'package:go_triunfo/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_up_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthViewModel extends ChangeNotifier {
  final SignUpUser signUpUser;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserModel? currentUser;
  String? errorMessage;
  bool isLoading = false;

  AuthViewModel({
    required this.signUpUser,
    required this.firebaseAuth,
    required this.firestore,
  });

  // Verificar si hay un usuario logueado y obtener sus datos
  Future<void> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser != null) {
      // Intentamos obtener los datos del usuario desde Firestore
      final userDoc =
          await firestore.collection('users').doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        currentUser = UserModel.fromJson(userDoc.data()!);
      } else {
        errorMessage = "Usuario no encontrado en Firestore.";
      }
    } else {
      currentUser = null;
    }

    notifyListeners();
  }

  // Método para manejar el registro de usuarios
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
    String? gender,
  }) async {
    _setLoading(true);

    final result = await signUpUser(
      SignUpParams(
        email: email,
        password: password,
        displayName: displayName,
        photoUrl: photoUrl,
        gender: gender,
      ),
    );

    _handleResult(result);
  }

  void _handleResult(Either<Failure, dynamic> result) {
    _setLoading(false);
    result.fold(
      (failure) {
        errorMessage = _mapFailureToMessage(failure);
      },
      (success) {
        errorMessage = null;
      },
    );
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  String? _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Ocurrió un error inesperado';
  }

  // Cerrar sesión
  Future<void> logout() async {
    await firebaseAuth.signOut();
    currentUser = null;
    notifyListeners();
  }
}

// Proveedor de Riverpod para AuthViewModel
final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final firebaseAuthDataSource = FirebaseAuthDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
  );

  final authRepository = AuthRepositoryImpl(firebaseAuthDataSource);

  return AuthViewModel(
    signUpUser: SignUpUser(authRepository),
    firebaseAuth: firebaseAuth,
    firestore: firestore,
  );
});
