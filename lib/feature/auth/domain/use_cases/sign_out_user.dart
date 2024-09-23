import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/core/usecases/usecase.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class SignOutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
