import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

class UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    if (authViewModel.isLoading || user == null) {
      return Center(child: CircularProgressIndicator()); // Mostrar un indicador de carga
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(user.email ?? 'Email no disponible'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            Text('Nivel: ${user.orders ?? 0}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Text('Dirección: ${user.address ?? 'No especificada'}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
