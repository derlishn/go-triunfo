// lib/data/repositories/user_repository.dart

import 'package:go_triunfo/data/models/user_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserById(String id);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}
