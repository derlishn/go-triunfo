import 'package:flutter/material.dart';
import 'package:go_triunfo/core/resources/strings.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/login_redirect.dart';
import 'package:go_triunfo/feature/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.registerHeader,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              RegisterForm(),
              SizedBox(height: 10),
              LoginRedirect(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
