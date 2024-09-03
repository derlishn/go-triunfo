import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/localizations.dart';
import 'package:go_triunfo/presentation/screens/auth/signin/widgets/loginForm.dart';
import 'package:go_triunfo/presentation/screens/auth/signin/widgets/signUpPrompt.dart';
import 'package:go_triunfo/presentation/screens/auth/signin/widgets/socialLoginButtons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.loginButtonText,
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
              SignUpPrompt(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
