import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Fetch current user data when HomeScreen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authViewModel.fetchCurrentUser();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: authViewModel.isLoading
            ? const CircularProgressIndicator() // Show loading indicator if still fetching data
            : authViewModel.currentUser == null
            ? const Text('No user data available') // Show a message if no user data is available
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${authViewModel.currentUser!.displayName}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${authViewModel.currentUser!.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.logout(context);
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
