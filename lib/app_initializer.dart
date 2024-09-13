import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/feature/auth/data/datasources/auth_data_source.dart';
import 'package:go_triunfo/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/get_current_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_in_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_out_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_up_user.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

import 'main.dart';

Future<Widget> initializeApp() async {
  // Asegúrate de que esta línea se ejecute antes de cualquier uso de Firebase
  await Firebase.initializeApp();  // Inicializar Firebase antes de cualquier operación

  // Inicializar Firebase Auth y Firestore
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final authDataSource = FirebaseAuthDataSource(auth: firebaseAuth, firestore: firestore);
  final authRepository = AuthRepositoryImpl(authDataSource: authDataSource);

  // Inicializar casos de uso
  final getCurrentUser = GetCurrentUser(authRepository);
  final signInUser = SignInUser(authRepository);
  final signUpUser = SignUpUser(authRepository);
  final signOutUser = SignOutUser(authRepository);

  // Crear el AuthViewModel
  final authViewModel = AuthViewModel(
    getCurrentUserUseCase: getCurrentUser,
    signInUserUseCase: signInUser,
    signUpUserUseCase: signUpUser,
    signOutUserUseCase: signOutUser,
  );

  // Retornar el MultiProvider con el ViewModel ya creado
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthViewModel>.value(
        value: authViewModel,
      ),
    ],
    child: const MyApp(), // Aquí aseguramos que el `MyApp` es pasado como `child`
  );
}
