import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_triunfo/presentation/viewmodels/auth_viewmodel.dart';

import '../../../data/providers/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authViewModel.signOut();
            Navigator.pushReplacementNamed(context, '/welcome');
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
