import 'package:flutter/material.dart';
import 'package:go_triunfo/core/strings/app_strings.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:provider/provider.dart';
import 'package:go_triunfo/core/utils/widgets/bottom_nav_bar.dart';
import 'package:go_triunfo/core/utils/widgets/drawer_menu.dart';
import '../../../../core/utils/widgets/show_notification_snackbar.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_category_list.dart';
import '../widgets/home_restaurant_list.dart';
import 'package:go_triunfo/feature/auth/presentation/manager/auth_viewmodel.dart';
import 'package:go_triunfo/feature/welcome/presentation/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthViewModel>(context, listen: false).loadUserSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        replaceAndRemoveUntil(context, const WelcomeScreen());
      });
      return const Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.titleApp,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                showNotificationBanner(context, AppStrings.functionIsNotFind);
              }),
          IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                showNotificationBanner(context, AppStrings.functionIsNotFind);
              }),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: DrawerMenu(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                HomeBanner(),
                HomeCategoryList(),
                HomeRestaurantList(),
              ],
            ),
          ),
        ],
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
