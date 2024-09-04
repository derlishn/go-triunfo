import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/core/resources/theme.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/firebase_options.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    // Inicialización asíncrona
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Espera la inicialización de Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Inicializa el estado del usuario actual
    await ref.read(authViewModelProvider).getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Si hay error durante la inicialización
        if (snapshot.hasError) {
          return const Center(child: Text('Error al inicializar la app'));
        }

        // Si aún se está inicializando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si la inicialización fue exitosa
        final authViewModel = ref.watch(authViewModelProvider);

        return MaterialApp(
          title: 'GoTriunfo App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: authViewModel.currentUser != null
              ? const HomeScreen()
              : const WelcomeScreen(),
        );
      },
    );
  }
}
