import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
