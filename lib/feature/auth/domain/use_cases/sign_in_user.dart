import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUser {
  final AuthRepository repository;

  SignInUser(this.repository);

  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}