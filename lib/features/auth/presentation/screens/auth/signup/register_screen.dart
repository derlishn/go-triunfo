import 'package:flutter/material.dart';
import 'package:go_triunfo/features/auth/presentation/screens/auth/signup/widgets/signInPrompt.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/register_form.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              RegisterForm(),
              SizedBox(height: 20),
              SignInPrompt(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
