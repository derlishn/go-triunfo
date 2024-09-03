import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<User?> signInWithGoogle();
  Stream<User?> get authStateChanges;
}
