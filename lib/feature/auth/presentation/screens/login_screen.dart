import 'package:flutter/material.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/login_form.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/register_direct.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/social_login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.loginButtonText,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              LoginForm(),
              SizedBox(height: 20),
              SocialLoginButtons(),
              SizedBox(height: 20),
              RegisterDirect(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
