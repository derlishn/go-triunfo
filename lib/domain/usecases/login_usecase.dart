import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/models/user_model.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<UserModel?> execute(String email, String password) async {
    final user = await _repository.signInWithEmailAndPassword(email, password);
    if (user == null) return null;
    return UserModel(id: user.uid, email: user.email!, displayName: user.displayName);
  }
}
