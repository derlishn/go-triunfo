import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    // Fetch user data once when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      if (authViewModel.currentUser == null) { // Only fetch if user is not already loaded
        authViewModel.fetchCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

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
