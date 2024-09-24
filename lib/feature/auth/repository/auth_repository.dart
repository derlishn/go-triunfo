import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/feature/auth/data/models/user_dto.dart';

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

      await _firestore
          .collection('users')
          .doc(userDTO.uid)
          .set(userDTO.toMap());

      return userDTO;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Este correo electrónico ya está en uso.';
          break;
        case 'invalid-email':
          errorMessage = 'El formato del correo electrónico es inválido.';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil. Por favor, elige una contraseña más segura.';
          break;
        default:
          errorMessage = 'Ocurrió un error al registrarte. Por favor, verifica tus datos e intenta nuevamente.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado. Por favor, intenta nuevamente.');
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
        throw Exception('No se encontraron datos de usuario. Por favor, contacta al soporte.');
      }

      UserDTO userDTO = UserDTO.fromMap(doc.data()!);
      return userDTO;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // Imprimir el código de error para depuración
      print('Código de error de FirebaseAuthException: ${e.code}');

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este correo electrónico.';
          break;
        case 'wrong-password':
          errorMessage = 'La contraseña ingresada es incorrecta.';
          break;
        case 'invalid-email':
          errorMessage = 'El formato del correo electrónico es inválido.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta cuenta ha sido deshabilitada. Por favor, contacta al soporte.';
          break;
        case 'too-many-requests':
          errorMessage = 'Has realizado muchos intentos. Por favor, intenta de nuevo más tarde.';
          break;
        default:
          errorMessage = 'Ocurrió un error al iniciar sesión. Por favor, verifica tus datos e intenta nuevamente.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Excepción no controlada: $e');
      throw Exception('Ocurrió un error inesperado. Por favor, intenta nuevamente.');
    }
  }


  Future<UserDTO?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        return null;
      }

      UserDTO userDTO = UserDTO.fromMap(doc.data()!);
      return userDTO;
    } catch (e) {
      throw Exception('Error al obtener el usuario actual: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }
}
