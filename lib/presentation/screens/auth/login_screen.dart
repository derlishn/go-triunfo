import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_triunfo/presentation/viewmodels/auth_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authViewModel = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.login(emailController.text, passwordController.text);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Register'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.signInWithGoogle();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
