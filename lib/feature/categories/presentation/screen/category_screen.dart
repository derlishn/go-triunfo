import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../category_viewmodel.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Explorar Categorías'),
      ),
      body: categoryViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : categoryViewModel.categories.isEmpty
          ? Center(child: Text('No hay categorías disponibles.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Muestra dos categorías por fila
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: categoryViewModel.categories.length,
          itemBuilder: (context, index) {
            final category = categoryViewModel.categories[index];

            return GestureDetector(
              onTap: () {
                // Aquí puedes navegar a una pantalla de productos filtrados por la categoría
                Navigator.pushNamed(context, '/products', arguments: category.id);
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.icon ?? '📦', // Muestra el icono de la categoría
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
