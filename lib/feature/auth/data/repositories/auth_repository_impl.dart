import 'package:dartz/dartz.dart';
import 'package:go_triunfo/core/errors/failures.dart';
import 'package:go_triunfo/feature/auth/data/data_sources/firebase_auth_datasource.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';
import 'package:go_triunfo/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;

  AuthRepositoryImpl(this.firebaseAuthDataSource);

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    String? displayName,
    String? photoUrl,
    String? gender,
  }) async {
    try {
      // Llamada al DataSource para crear un nuevo usuario en Firebase
      final userModel = await firebaseAuthDataSource.signUp(
        email: email,
        password: password,
        displayName: displayName,
        photoUrl: photoUrl,
        gender: gender,
      );

      // Retorna el UserModel envuelto en Right si todo va bien
      return Right(userModel);
    } catch (e) {
      // En caso de error, retorna una Failure envuelta en Left
      return Left(ServerFailure(e.toString()));
    }
  }
}
