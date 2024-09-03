import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../viewmodels/auth_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authProvider.notifier);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authViewModel.signOut();
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Text('Cerrar Sesión'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authState.user != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bienvenido ${authState.user!.displayName ?? ''}!')),
            );
          }
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
