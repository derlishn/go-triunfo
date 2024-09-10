import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/get_current_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_in_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_out_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_up_user.dart';
import 'package:go_triunfo/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_triunfo/feature/auth/data/datasources/auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/feature/auth/presentation/screens/login_screen.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';

import 'core/resources/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Inicialización de FirebaseAuth y Firestore para el DataSource
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Crear instancia del AuthDataSource
  final authDataSource = FirebaseAuthDataSource(auth: firebaseAuth, firestore: firestore);

  // Crear instancia del AuthRepositoryImpl
  final authRepository = AuthRepositoryImpl(authDataSource: authDataSource);

  // Correr la aplicación con MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            getCurrentUserUseCase: GetCurrentUser(authRepository),
            signInUserUseCase: SignInUser(authRepository),
            signUpUserUseCase: SignUpUser(authRepository),
            signOutUserUseCase: SignOutUser(authRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoTriunfo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
