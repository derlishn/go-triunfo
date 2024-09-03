import 'package:flutter/material.dart';
import 'package:go_triunfo/presentation/screens/auth/signin/login_screen.dart';
import 'package:go_triunfo/presentation/screens/auth/signup/register_screen.dart';
import 'package:go_triunfo/presentation/screens/home/home_screen.dart';
import 'package:go_triunfo/presentation/screens/welcome/welcome_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
