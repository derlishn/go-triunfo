import 'package:flutter/material.dart';
import 'package:go_triunfo/feature/business/manager_business_screen.dart';
import 'package:go_triunfo/feature/home/presentation/widgets/manager_banner_screen.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import '../../../feature/categories/presentation/screen/manager_category_screen.dart';
import '../../../feature/home/presentation/screens/home_screen.dart';
import '../../../feature/profile/presentations/screens/profile_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authViewModel.currentUser?.displayName ?? 'Usuario'),
            accountEmail: Text(authViewModel.currentUser?.email ?? 'Email'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                authViewModel.currentUser?.displayName?.substring(0, 1) ?? 'U',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              replaceWith(context, HomeScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              navigateTo(context, ProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_add),
            title: Text('Banners'),
            onTap: () {
              navigateTo(context, ManagerBannersScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categorías'),
            onTap: () {
              navigateTo(context, ManagerCategoriesScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Negocios'),
            onTap: () {
              navigateTo(context, ManagerBusinessScreen());
            },
          ),
          Expanded(child: Text(""),),
          Expanded(child: Text(""),),
          Expanded(child: Text(""),),
          Expanded(child: Text(""),),
          Expanded(child: Text(""),),
          Expanded(child: Text(""),),
          Divider(), // Línea divisoria para separar el contenido principal del área de configuración y logout
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              // Aquí podrías navegar a una pantalla de configuración si la tienes
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () async {
              await authViewModel.signOut();
              replaceAndRemoveUntil(context, WelcomeScreen());
            },
          ),
        ],
      ),
    );
  }
}
