import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/product_dto.dart';
import '../manager/product_viewmodel.dart';

class ProductForm extends StatefulWidget {
  final ProductDTO? product;

  const ProductForm({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late String _imageUrl;
  late String _categoryId;
  late String _ownerId;
  late int _stock;
  late double _rating;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Si se pasa un producto, llenamos los campos para editar
      _name = widget.product!.name;
      _description = widget.product!.description;
      _price = widget.product!.price;
      _imageUrl = widget.product!.imageUrl;
      _categoryId = widget.product!.categoryId;
      _ownerId = widget.product!.ownerId;
      _stock = widget.product!.stock;
      _rating = widget.product!.rating;
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      _imageUrl = '';
      _categoryId = '';
      _ownerId = '';
      _stock = 0;
      _rating = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

    return AlertDialog(
      title: Text(widget.product != null ? 'Editar Producto' : 'Agregar Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'El nombre es requerido' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _description = value!,
                validator: (value) => value!.isEmpty ? 'La descripción es requerida' : null,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'El precio es requerido' : null,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'URL de la Imagen'),
                onSaved: (value) => _imageUrl = value!,
                validator: (value) => value!.isEmpty ? 'La URL de la imagen es requerida' : null,
              ),
              // Otros campos adicionales como categoría, propietario, stock, etc.
              TextFormField(
                initialValue: _stock.toString(),
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _stock = int.parse(value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              ProductDTO product = ProductDTO(
                id: widget.product?.id ?? DateTime.now().toString(),
                name: _name,
                description: _description,
                price: _price,
                imageUrl: _imageUrl,
                categoryId: _categoryId,
                ownerId: _ownerId,
                stock: _stock,
                rating: _rating,
              );

              if (widget.product == null) {
                await productViewModel.addProduct(product);
              } else {
                await productViewModel.updateProduct(product);
              }

              Navigator.of(context).pop();
            }
          },
          child: Text(widget.product != null ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}
