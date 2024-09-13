import 'dart:io';

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
    } on Failure catch (failure) {
      // Aquí atrapamos el Failure lanzado por el dataSource y lo retornamos tal cual
      return Left(failure);
    } catch (e) {
      // Si es cualquier otro tipo de error, devolvemos un mensaje genérico
      return Left(ServerFailure('Error desconocido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(User user, String password) async {
    try {
      final userModel = UserModel(
        uid: '', // El UID será generado por Firebase
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        address: user.address,
        photoUrl: user.photoUrl,
        createdAt: user.createdAt,
        role: user.role,
        gender: user.gender,
        orders: user.orders,
      );

      final signedUpUser = await authDataSource.signUp(userModel, password);
      return Right(signedUpUser);
    } on Failure catch (failure) {
      return Left(failure); // Retorna el Failure tal como fue lanzado
    } catch (e) {
      return Left(ServerFailure('Error! Intentalo más tarde'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(null);
    } on Failure catch (failure) {
      // Aquí atrapamos el Failure lanzado por el dataSource y lo retornamos tal cual
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Error desconocido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await authDataSource.getCurrentUser();
      return Right(user);
    } on Failure catch (failure) {
      // Aquí atrapamos el Failure lanzado por el dataSource y lo retornamos tal cual
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Error desconocido: ${e.toString()}'));
    }
  }
}
