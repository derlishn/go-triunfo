import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class SignOutUser {
  final AuthRepository repository;

  SignOutUser(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
