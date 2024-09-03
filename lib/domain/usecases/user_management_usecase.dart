import 'package:go_triunfo/data/models/user_model.dart';
import 'package:go_triunfo/data/repositories/user_repository.dart';

class UserManagementUseCase {
  final UserRepository _userRepository;

  UserManagementUseCase(this._userRepository);

  Future<void> createUser(UserModel user) async {
    await _userRepository.createUser(user);
  }

  Future<UserModel?> getUserById(String uid) async {
    return await _userRepository.getUserById(uid);
  }

  Future<void> updateUser(UserModel user) async {
    await _userRepository.updateUser(user);
  }

  Future<void> deleteUser(String uid) async {
    await _userRepository.deleteUser(uid);
  }
}
