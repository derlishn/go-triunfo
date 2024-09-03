import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_triunfo/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password, UserModel userModel);
  Future<void> signOut();
  Future<User?> signInWithGoogle();
  Stream<User?> get authStateChanges;
}
