import 'package:go_triunfo/data/models/user_model.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final UserManagementUseCase _userManagementUseCase;

  LoginUseCase(this._authRepository, this._userManagementUseCase);

  Future<UserModel?> execute(String email, String password) async {
    final user = await _authRepository.signInWithEmailAndPassword(email, password);
    if (user != null) {
      final userModel = await _userManagementUseCase.getUserById(user.uid);
      if (userModel != null && userModel.isActive) {
        return userModel;
      }
    }
    return null;
  }
}
