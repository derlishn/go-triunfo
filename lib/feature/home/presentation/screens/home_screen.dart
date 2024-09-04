import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/core/utils/navigation/navigator_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final currentUser = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              replaceWith(context, const WelcomeScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentUser.photoUrl != null)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(currentUser.photoUrl!),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Hola, ${currentUser.displayName}!',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Correo: ${currentUser.email}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              )
            : const Text('No se pudo cargar la información del usuario.'),
      ),
    );
  }
}
