import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/models/user_model.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

class GoogleSignInUseCase {
  final AuthRepository _repository;
  final UserManagementUseCase _userManagementUseCase;

  GoogleSignInUseCase(this._repository, this._userManagementUseCase);

  Future<UserModel?> execute() async {
    final user = await _repository.signInWithGoogle();
    if (user == null) return null;

    // Verificar si el usuario ya existe en Firestore
    var userModel = await _userManagementUseCase.getUserById(user.uid);
    if (userModel == null) {
      // Si no existe, crearlo en Firestore
      userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL ?? 'default_photo_url',
        gender: 'not-specified', // Puedes ajustar esto según tu necesidad
        role: 'user', // Rol por defecto
        isActive: true, // Por defecto, el usuario está activo
        createdAt: DateTime.now(),
      );
      await _userManagementUseCase.createUser(userModel);
    }

    return userModel;
  }

  Stream<User?> authStateChanges() {
    return _repository.authStateChanges;
  }
}
