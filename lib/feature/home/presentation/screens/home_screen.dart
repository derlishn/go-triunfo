import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.currentUser != null) {
      authViewModel.listenToUserUpdates(authViewModel.currentUser!.uid);
    } else {
      // Verifica si la sesión está cargada desde SharedPreferences
      authViewModel.loadUserSession().then((user) {
        if (user != null) {
          authViewModel.currentUser = user;
          setState(() {});  // Notificar a la UI que hay cambios
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authViewModel.signOut(); // Cerrar sesión
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: authViewModel.isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : authViewModel.currentUser == null
          ? const Center(child: Text('No se encontró información de usuario.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Usuario:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildUserInfo('UID', authViewModel.currentUser!.uid),
            _buildUserInfo('Nombre', authViewModel.currentUser!.displayName),
            _buildUserInfo('Correo', authViewModel.currentUser!.email),
            _buildUserInfo('Teléfono', authViewModel.currentUser!.phoneNumber ?? 'No especificado'),
            _buildUserInfo('Dirección', authViewModel.currentUser!.address ?? 'No especificado'),
            _buildUserInfo('Género', authViewModel.currentUser!.gender),
            _buildUserInfo('Rol', authViewModel.currentUser!.role),
            _buildUserInfo('Pedidos', authViewModel.currentUser!.orders.toString()),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authViewModel.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                },
                child: const Text('Cerrar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para construir la información del usuario
  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
