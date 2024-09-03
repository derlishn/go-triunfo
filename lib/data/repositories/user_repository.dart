import 'package:go_triunfo/domain/models/user_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserByUid(String uid); // Cambiado de id a uid
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String uid); // Cambiado de id a uid
}
