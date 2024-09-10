import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_triunfo/feature/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(UserModel user, String password); // Password ahora es dinámico
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

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;

      // Obtener los datos del usuario desde Firestore
      final docSnapshot = await firestore.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        throw Exception('User data not found in Firestore');
      }
    } catch (e) {
      // Manejo de errores de autenticación y Firestore
      throw Exception('Error signing in: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp(UserModel user, String password) async {
    try {
      // Registrar el usuario en Firebase Authentication
      final credential = await auth.createUserWithEmailAndPassword(email: user.email, password: password);

      // Crear el modelo del usuario con el UID generado por Firebase
      final userModel = user.copyWith(uid: credential.user!.uid);

      // Guardar los datos del usuario en Firestore
      final userDoc = firestore.collection('users').doc(credential.user!.uid);
      await userDoc.set(userModel.toJson());

      return userModel;
    } catch (e) {
      // Manejo de errores de registro y Firestore
      throw Exception('Error signing up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      // Manejo de errores en el cierre de sesión
      throw Exception('Error signing out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = auth.currentUser;
      if (firebaseUser != null) {
        final docSnapshot = await firestore.collection('users').doc(firebaseUser.uid).get();
        if (docSnapshot.exists) {
          return UserModel.fromJson(docSnapshot.data()!);
        } else {
          throw Exception('User data not found in Firestore');
        }
      }
      return null;
    } catch (e) {
      // Manejo de errores al obtener el usuario actual
      throw Exception('Error fetching current user: ${e.toString()}');
    }
  }
}
