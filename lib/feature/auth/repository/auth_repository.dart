import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/user_dto.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserDTO> signUp(UserDTO userDTO, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: userDTO.email,
        password: password,
      );

      userDTO = userDTO.copyWith(
        uid: credential.user!.uid,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userDTO.uid).set(userDTO.toMap());

      return userDTO;
    } catch (e) {
      throw Exception(AuthErrors.getMessage(e));
    }
  }

  Future<UserDTO> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!doc.exists) {
        throw Exception('No se encontraron datos de usuario.');
      }

      UserDTO userDTO = UserDTO.fromMap(doc.data()!);
      return userDTO;
    } catch (e) {
      throw Exception(AuthErrors.getMessage(e));
    }
  }

  Future<UserDTO?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        return null;
      }

      UserDTO userDTO = UserDTO.fromMap(doc.data()!);
      return userDTO;
    } catch (e) {
      throw Exception('Error al obtener el usuario actual.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión.');
    }
  }
}

class AuthErrors {
  static String getMessage(dynamic exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'email-already-in-use':
          return 'Este correo electrónico ya está en uso.';
        case 'invalid-email':
          return 'El formato del correo electrónico es inválido.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'user-not-found':
          return 'No existe una cuenta con este correo electrónico.';
        case 'wrong-password':
          return 'La contraseña ingresada es incorrecta.';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada.';
        case 'too-many-requests':
          return 'Has realizado demasiados intentos. Intenta más tarde.';
        default:
          return 'Ocurrió un error al autenticar. Intenta nuevamente.';
      }
    } else {
      return 'Error inesperado. Intenta nuevamente.';
    }
  }
}
