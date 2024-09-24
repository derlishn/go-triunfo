import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/categories/presentation/screen/category_screen.dart';
import 'package:provider/provider.dart';
import '../../../categories/presentation/category_viewmodel.dart';

class HomeCategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Container(
      height: 180, // Altura ajustada para dar espacio a las categorías
      child: categoryViewModel.isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar loading
          : categoryViewModel.categories.isEmpty
          ? Center(child: Text('No hay categorías disponibles')) // Lista vacía
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    navigateTo(context, CategoryScreen());
                  },
                  child: Text(
                    'Ver todas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryViewModel.categories.length > 6
                  ? 6
                  : categoryViewModel.categories.length,
              itemBuilder: (context, index) {
                final category = categoryViewModel.categories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          category.icon ?? '📦', // Muestra ícono o el ícono por defecto
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ), // Mostrar el nombre de la categoría
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
