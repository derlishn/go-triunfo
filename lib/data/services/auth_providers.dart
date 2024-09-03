import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/data/repositories/auth_repository.dart';
import 'package:go_triunfo/data/repositories/auth_repository_impl.dart';
import 'package:go_triunfo/data/repositories/user_repository.dart';
import 'package:go_triunfo/data/repositories/user_repository_impl.dart';
import 'package:go_triunfo/domain/usecases/google_sign_in_usecase.dart';
import 'package:go_triunfo/domain/usecases/login_usecase.dart';
import 'package:go_triunfo/domain/usecases/logout_usecase.dart';
import 'package:go_triunfo/domain/usecases/register_usecase.dart';
import 'package:go_triunfo/domain/usecases/user_management_usecase.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    FirebaseAuth.instance,
    GoogleSignIn(),
    FirebaseFirestore.instance,  // Pass the Firestore instance here
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    FirebaseFirestore.instance,
  );
});

final userManagementUseCaseProvider = Provider((ref) => UserManagementUseCase(ref.read(userRepositoryProvider)));

final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider), ref.read(userManagementUseCaseProvider)));
final registerUseCaseProvider = Provider((ref) => RegisterUseCase(ref.read(authRepositoryProvider), ref.read(userManagementUseCaseProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));
final googleSignInUseCaseProvider = Provider((ref) => GoogleSignInUseCase(ref.read(authRepositoryProvider), ref.read(userManagementUseCaseProvider)));
