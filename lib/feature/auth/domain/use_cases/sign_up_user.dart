import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/core/usecases/usecase.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class SignUpUser implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpUser(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params.user, params.password);
  }
}

class SignUpParams {
  final User user;
  final String password;

  SignUpParams({required this.user, required this.password});
}
