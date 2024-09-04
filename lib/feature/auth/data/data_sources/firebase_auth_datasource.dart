import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/core/errors/exceptions.dart';
import 'package:go_triunfo/feature/auth/data/models/user_model.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
    String? gender,
  });
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
    String? gender,
  }) async {
    try {
      // Crea un nuevo usuario con email y contraseña en Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw ServerException('Error during sign-up');
      }

      // Crea un modelo de usuario para guardar en Firestore
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: displayName,
        photoUrl: photoUrl,
        gender: gender,
        role: 'user', // Rol predeterminado
        isActive: true, // Estado activo predeterminado
        createdAt: DateTime.now(),
      );

      // Guarda el modelo de usuario en Firestore bajo la colección 'users'
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toJson());

      return userModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
