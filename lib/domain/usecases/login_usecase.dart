import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../models/user_model.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginUseCase(this._authRepository, this._userRepository);

  Future<UserModel?> login(String email, String password) async {
    try {
      final user = await _authRepository.signInWithEmailAndPassword(email, password);
      if (user != null) {
        return await _userRepository.getUserByUid(user.uid);
      }
    } catch (e) {
      print('Error en el login: $e');
    }
    return null;
  }
}
