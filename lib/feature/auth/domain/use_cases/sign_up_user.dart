import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class SignUpUser {
  final AuthRepository repository;

  SignUpUser(this.repository);

  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
      photoUrl: params.photoUrl,
      gender: params.gender,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String? displayName;
  final String? photoUrl;
  final String? gender;

  SignUpParams({
    required this.email,
    required this.password,
    this.displayName,
    this.photoUrl,
    this.gender,
  });
}
