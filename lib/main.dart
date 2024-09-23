import 'package:flutter/material.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/theme/app_theme.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = await initializeApp();
  runApp(appProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.titleApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
