import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/domain/models/user_model.dart';

class GoogleSignInUseCase {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  Future<UserModel?> execute() async {
    final user = await _repository.signInWithGoogle();
    if (user == null) return null;
    return UserModel(id: user.uid, email: user.email!, displayName: user.displayName);
  }

  Stream<User?> authStateChanges() {
    return _repository.authStateChanges;
  }
}
