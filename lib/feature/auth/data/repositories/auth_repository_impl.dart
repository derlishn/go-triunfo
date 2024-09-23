import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signUp(User user, String password) async {
    try {
      final firebaseUser = await remoteDataSource.signUp(user.email, password);
      return Right(UserModel.fromFirebaseUser(firebaseUser));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final firebaseUser = await remoteDataSource.signIn(email, password);
      return Right(UserModel.fromFirebaseUser(firebaseUser));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final firebaseUser = await remoteDataSource.getCurrentUser();
      return Right(firebaseUser != null ? UserModel.fromFirebaseUser(firebaseUser) : null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
