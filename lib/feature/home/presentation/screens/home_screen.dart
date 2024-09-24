import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/widgets/bottom_nav_bar.dart';
import '../../../../core/utils/widgets/drawer_menu.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_category_list.dart';
import '../widgets/home_restaurant_list.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Cargar el usuario al iniciar la pantalla
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.loadUserSession(); // Cargar sesión desde SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('GoTriunfo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Acción de notificaciones
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeBanner(), // Widget del banner principal
            HomeCategoryList(), // Widget de lista de categorías
            HomeRestaurantList(), // Widget de lista de restaurantes
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
