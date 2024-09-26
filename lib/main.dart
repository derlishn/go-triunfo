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

  final authViewModel = AuthViewModel();
  final UserDTO? currentUser = await authViewModel.loadUserSession();
  print('Usuario cargado desde SharedPreferences: $currentUser');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => authViewModel,
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (_) => ProductViewModel(),
        ),
        ChangeNotifierProvider<CategoryViewModel>(
          create: (_) => CategoryViewModel()..fetchCategories(),
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
  final UserDTO? user;

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.titleApp,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: user != null ? HomeScreen() : const WelcomeScreen(),
    );
  }
}
