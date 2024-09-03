import 'package:go_triunfo/data/models/user_model.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;
  final UserManagementUseCase _userManagementUseCase;

  RegisterUseCase(this._authRepository, this._userManagementUseCase);

  Future<UserModel?> execute(
      String email,
      String password,
      String displayName,
      String gender,
      ) async {
    final user = await _authRepository.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: displayName,
        photoUrl: 'default_photo_url',
        createdAt: DateTime.now(),
        gender: gender,
        role: 'user',
        isActive: true,
      );
      await _userManagementUseCase.createUser(userModel);
      return userModel;
    }
    return null;
  }
}
