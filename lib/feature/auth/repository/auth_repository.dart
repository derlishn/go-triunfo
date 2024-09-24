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
      print('Error during sign-up: $e');  // Debugging purposes
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
      print('Error during sign-in: $e');  // Debugging purposes
      throw Exception(AuthErrors.getMessage(e));
    }
  }

  Future<UserDTO?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      UserDTO userDTO = UserDTO.fromMap(doc.data()!);
      return userDTO;
    } catch (e) {
      print('Error getting current user: $e');  // Debugging purposes
      throw Exception('Error al obtener el usuario actual.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign-out: $e');  // Debugging purposes
      throw Exception('Error al cerrar sesión.');
    }
  }

  Stream<UserDTO> listenToUserUpdates(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        return UserDTO.fromJson(data);  // Convertir a UserDTO
      } else {
        throw Exception('No se encontraron datos de usuario.');
      }
    });
  }
  // Función para actualizar los datos del usuario en Firebase
  Future<void> updateUser(UserDTO userDTO) async {
    try {
      await _firestore.collection('users').doc(userDTO.uid).update(userDTO.toMap());
    } catch (e) {
      throw Exception('Error actualizando datos del usuario: $e');
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
