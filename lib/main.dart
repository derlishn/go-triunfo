import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/theme/app_theme.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/feature/home/presentation/screens/home_screen.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'feature/auth/data/models/user_dto.dart';
import 'feature/business/business_viewmodel.dart';
import 'feature/categories/presentation/category_viewmodel.dart';
import 'feature/home/presentation/manager/banner_viewmodel.dart';
import 'feature/product/presentation/manager/product_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializar Firebase
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Cargar sesión del usuario antes de iniciar la app
  final authViewModel = AuthViewModel();
  final UserDTO? currentUser = await authViewModel.loadUserSession(); // Cargar usuario desde SharedPreferences
  print('Usuario cargado desde SharedPreferences: $currentUser'); // Debug

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => authViewModel,  // Usamos la instancia ya creada
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (_) => ProductViewModel(),
        ),
        ChangeNotifierProvider<CategoryViewModel>(
          create: (_) => CategoryViewModel()..fetchCategories(), // Cargar categorías al inicio
        ),
        ChangeNotifierProvider<BusinessViewModel>(
          create: (_) => BusinessViewModel()..fetchBusinesses(),
        ),
        ChangeNotifierProvider(
          create: (_) => BannerViewModel()..fetchBanners(),
          child: HomeScreen(),
        )

      ],
      child: MyApp(user: currentUser),
    ),
  );
}


class MyApp extends StatelessWidget {
  final UserDTO? user;  // Recibimos el usuario cargado de SharedPreferences

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.titleApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: user != null ? HomeScreen() : const WelcomeScreen(), // Dependiendo si el usuario está cargado o no
    );
  }
}
