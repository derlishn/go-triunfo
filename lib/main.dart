import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'core/resources/theme.dart';
import 'app_initializer.dart';  // Importar la función de inicialización
import 'firebase_options.dart';  // Importar el archivo generado por Firebase CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar la app y obtener el MultiProvider con los ViewModels
  final appProvider = await initializeApp();

  // Ejecutar la aplicación con el MultiProvider correctamente configurado
  runApp(appProvider);
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
