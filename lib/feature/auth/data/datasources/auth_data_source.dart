import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_triunfo/feature/auth/data/models/user_model.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(UserModel user, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class FirebaseAuthDataSource implements AuthDataSource {
  final firebase_auth.FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel> signUp(UserModel user, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);
      final userModel = user.copyWith(uid: credential.user!.uid);
      await _saveUserToFirestore(userModel);
      return userModel;
    } on SocketException {
      // Captura específicamente la falta de conexión a Internet.
      throw NetworkFailure('No hay conexión a Internet.');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return await _fetchUserFromFirestore(credential.user!.uid);
    } catch (e) {
      throw _handleAuthError(e); // Lanza la excepción correctamente
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw ServerFailure('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = auth.currentUser;
      if (firebaseUser != null) {
        return await _fetchUserFromFirestore(firebaseUser.uid);
      }
      return null;
    } catch (e) {
      throw ServerFailure(
          'Error al obtener el usuario actual: ${e.toString()}');
    }
  }

  // Guardar los datos del usuario en Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    final userDoc = firestore.collection('users').doc(user.uid);
    await userDoc.set(user.toJson());
  }

  // Obtener los datos del usuario desde Firestore
  Future<UserModel> _fetchUserFromFirestore(String uid) async {
    final docSnapshot = await firestore.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      return UserModel.fromJson(docSnapshot.data()!);
    } else {
      throw ServerFailure(
          'Los datos del usuario no se encontraron en Firestore.');
    }
  }

  Failure _handleAuthError(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return ServerFailure('Este correo electrónico ya está en uso.');
        case 'invalid-email':
          return ServerFailure('El correo electrónico no es válido.');
        case 'weak-password':
          return ServerFailure('La contraseña es demasiado débil.');
        case 'wrong-password':
          return ServerFailure('Contraseña incorrecta. Inténtalo de nuevo.');
        case 'user-not-found':
          return ServerFailure('Usuario no encontrado. Regístrate primero.');
        default:
          return ServerFailure('Error! Intentalo más tarde');
      }
    } else {
      return ServerFailure('Error inesperado: ${error.toString()}');
    }
  }
}