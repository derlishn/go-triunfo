import 'package:go_triunfo/data/repositories/user_repository.dart';
import 'package:go_triunfo/domain/models/user_model.dart';

class UserManagementUseCase {
  final UserRepository userRepository;

  UserManagementUseCase(this.userRepository);

  Future<void> createUser(UserModel user) async {
    await userRepository.createUser(user);
  }

  Future<UserModel?> getUserById(String uid) async {
    return await userRepository.getUserById(uid);
  }

  Future<void> updateUser(UserModel user) async {
    await userRepository.updateUser(user);
  }

  Future<void> deleteUser(String uid) async {
    await userRepository.deleteUser(uid);
  }

  Future<void> deactivateUser(String uid) async {
    // Obtén el usuario actual
    final user = await getUserById(uid);
    if (user != null) {
      // Actualiza el estado del usuario a inactivo
      final updatedUser = user.copyWith(isActive: false);
      await updateUser(updatedUser);
    }
  }

  Future<void> activateUser(String uid) async {
    // Obtén el usuario actual
    final user = await getUserById(uid);
    if (user != null) {
      // Actualiza el estado del usuario a activo
      final updatedUser = user.copyWith(isActive: true);
      await updateUser(updatedUser);
    }
  }
}
