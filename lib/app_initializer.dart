import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_triunfo/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_in_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_up_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/get_current_user.dart';
import 'package:go_triunfo/feature/auth/domain/use_cases/sign_out_user.dart';
import 'firebase_options.dart'; // Archivo de configuración de Firebase
import 'main.dart';

Future<MultiProvider> initializeApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final authRemoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth: firebaseAuth);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

  await initializeAppCheck();

  final signInUser = SignInUser(authRepository);
  final signUpUser = SignUpUser(authRepository);
  final getCurrentUser = GetCurrentUser(authRepository);
  final signOutUser = SignOutUser(authRepository);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthViewModel(
          signInUser: signInUser,
          signUpUser: signUpUser,
          getCurrentUser: getCurrentUser,
          signOutUser: signOutUser,
        ),
      ),
    ],
    child: const MyApp(), // Aseguramos que el child sea la clase MyApp
  );
}


Future<void> initializeAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug, // Token de prueba para Android
      appleProvider: AppleProvider.debug,     // Token de prueba para iOS
    );
    print('Firebase App Check activado con éxito');
  } catch (e) {
    print('Error al activar Firebase App Check: $e');
  }
}


