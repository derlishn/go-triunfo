import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/product_dto.dart';
import '../manager/product_viewmodel.dart';
import '../widgets/product_form.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
      ),
      body: productViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: productViewModel.products.length,
        itemBuilder: (context, index) {
          final product = productViewModel.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} Lempiras'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showProductForm(context, product: product); // Editar producto
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await productViewModel.deleteProduct(product.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showProductForm(context); // Agregar nuevo producto
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Mostrar formulario para agregar o editar producto
  void _showProductForm(BuildContext context, {ProductDTO? product}) {
    showDialog(
      context: context,
      builder: (context) {
        return ProductForm(
          product: product, // Si se proporciona un producto, se editará, si no, se creará uno nuevo
        );
      },
    );
  }
}
