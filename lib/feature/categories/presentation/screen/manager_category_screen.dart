import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../category_viewmodel.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/edit_category_dialog.dart';

class ManagerCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Categorías'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Mostrar el diálogo para agregar nueva categoría
              showDialog(
                context: context,
                builder: (context) => AddCategoryDialog(),
              );
            },
          ),
        ],
      ),
      body: categoryViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : categoryViewModel.categories.isEmpty
          ? Center(child: Text('No hay categorías disponibles.'))
          : ListView.builder(
        itemCount: categoryViewModel.categories.length,
        itemBuilder: (context, index) {
          final category = categoryViewModel.categories[index];
          return ListTile(
            title: Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(category.icon ?? '📦'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: category.isActive,
                  onChanged: (value) {
                    categoryViewModel.toggleCategoryStatus(
                        category.id, value);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Mostrar diálogo para editar la categoría
                    showDialog(
                      context: context,
                      builder: (context) =>
                          EditCategoryDialog(category: category),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(context, categoryViewModel, category.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Confirmar eliminación de categoría
  void _confirmDelete(BuildContext context, CategoryViewModel viewModel, String categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Categoría'),
        content: Text('¿Estás seguro de que deseas eliminar esta categoría?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteCategory(categoryId);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
