import 'package:go_triunfo/data/models/user_model.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;
  final UserManagementUseCase _userManagementUseCase;

  GoogleSignInUseCase(this._authRepository, this._userManagementUseCase);

  Future<UserModel?> execute() async {
    final user = await _authRepository.signInWithGoogle();
    if (user != null) {
      final userModel = await _userManagementUseCase.getUserById(user.uid);
      if (userModel == null) {
        // If the user is not found, create a new one in the Firestore
        final newUserModel = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL ?? 'default_photo_url',
          createdAt: DateTime.now(),
          gender: 'Not specified',
          role: 'user',
          isActive: true,
        );
        await _userManagementUseCase.createUser(newUserModel);
        return newUserModel;
      } else if (userModel.isActive) {
        return userModel;
      }
    }
    return null;
  }

  Stream<UserModel?> authStateChanges() {
    return _authRepository.authStateChanges.map((user) async {
      if (user != null) {
        return await _userManagementUseCase.getUserById(user.uid);
      }
      return null;
    }).asyncMap((event) async => await event);
  }
}
