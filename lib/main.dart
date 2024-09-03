import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/core/theme/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/firebase_options.dart';
import 'features/auth/presentation/screens/home/home_screen.dart';
import 'features/auth/presentation/screens/welcome/welcome_screen.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authProvider.notifier);
    final isAuthenticated = authViewModel.isAuthenticated();

    return MaterialApp(
      title: 'GoTriunfo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isAuthenticated ? HomeScreen() : const WelcomeScreen(),
    );
  }
}
