import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/data/datasources/auth_data_source.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:go_triunfo/feature/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await authDataSource.signIn(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(User user, String password) async {
    try {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        address: user.address,
        photoUrl: user.photoUrl,
        createdAt: user.createdAt,
        role: user.role,
        accountStatus: user.accountStatus,
        gender: user.gender, // Add gender field
        orders: user.orders, // Add orders field, initially 0
      );
      final signedUpUser = await authDataSource.signUp(userModel, password); // Pass the password dynamically
      return Right(signedUpUser);
    } catch (e) {
      return Left(ServerFailure('Failed to sign up: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to sign out: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await authDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch current user: ${e.toString()}'));
    }
  }
}
