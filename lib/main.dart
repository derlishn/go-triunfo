import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/core/resources/theme.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/firebase_options.dart';

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
    return MaterialApp(
        title: 'GoTriunfo App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const WelcomeScreen());
  }
}
