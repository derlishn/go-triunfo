import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
    String? gender,
  });
}
