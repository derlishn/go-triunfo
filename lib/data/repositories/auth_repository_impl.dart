import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_repository.dart';
import 'package:go_triunfo/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;  // Add this line

  AuthRepositoryImpl(
      this._firebaseAuth,
      this._googleSignIn,
      this._firestore,  // Add this line
      );

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // Create a new document in Firestore with default values if it's a new user
        final newUser = UserModel(
          uid: user.uid,
          email: user.email!,
          displayName: user.displayName ?? 'Anonymous',
          createdAt: DateTime.now(),
          gender: 'Not specified',
          role: 'user',
          isActive: true,
          photoUrl: user.photoURL ?? 'default_photo_url',
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }
    }
    return user;
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
