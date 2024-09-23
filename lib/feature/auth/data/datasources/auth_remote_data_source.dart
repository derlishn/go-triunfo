import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_triunfo/core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<firebase_auth.User> signUp(String email, String password);
  Future<firebase_auth.User> signIn(String email, String password);
  Future<void> signOut();
  Future<firebase_auth.User?> getCurrentUser();
}
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<firebase_auth.User> signUp(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Imprime el código y el mensaje del error de Firebase para depuración
      print('FirebaseAuthException Code: ${e.code}');
      print('FirebaseAuthException Message: ${e.message}');
      throw ServerException(_mapFirebaseAuthExceptionToMessage(e));
    }
  }

  @override
  Future<firebase_auth.User> signIn(String email, String password) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Imprime el código y el mensaje del error de Firebase para depuración
      print('FirebaseAuthException Code: ${e.code}');
      print('FirebaseAuthException Message: ${e.message}');
      throw ServerException(_mapFirebaseAuthExceptionToMessage(e));
    }
  }

  String _mapFirebaseAuthExceptionToMessage(firebase_auth.FirebaseAuthException e) {
    print('Mapeando el código de error: ${e.code}');
    switch (e.code) {
      case 'invalid-credential':
        return 'Las credenciales proporcionadas no son válidas. Por favor, verifica tu información y vuelve a intentarlo.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada. Ponte en contacto con el soporte para obtener más ayuda.';
      case 'user-not-found':
        return 'No se encontró ninguna cuenta con este correo. Verifica tu información o regístrate si aún no lo has hecho.';
      case 'wrong-password':
        return 'La contraseña es incorrecta. Inténtalo de nuevo o restablece tu contraseña si la has olvidado.';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso. Intenta iniciar sesión o utiliza otro correo.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido. Por favor, introduce un correo válido.';
      case 'operation-not-allowed':
        return 'El inicio de sesión con este método ha sido deshabilitado. Ponte en contacto con soporte.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Utiliza una combinación de letras, números y símbolos.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Por favor, espera un momento antes de intentarlo de nuevo.';
      case 'network-request-failed':
        return 'No se pudo conectar a la red. Verifica tu conexión a internet y vuelve a intentarlo.';
      case 'app-not-authorized':
        return 'Esta aplicación no está autorizada para autenticarse. Verifica la configuración de Firebase.';
      case 'account-exists-with-different-credential':
        return 'Una cuenta con el mismo correo ya existe pero con credenciales diferentes. Intenta iniciar sesión de otra manera.';
      default:
        return 'Ocurrió un error inesperado. Por favor, inténtalo más tarde.';
    }
  }


  @override
  Future<firebase_auth.User?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
