import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../categories/presentation/category_viewmodel.dart';
import 'business_dto.dart';
import 'business_viewmodel.dart';

class BusinessFormScreen extends StatefulWidget {
  @override
  _BusinessFormScreenState createState() => _BusinessFormScreenState();
}

class _BusinessFormScreenState extends State<BusinessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _selectedCategoryId = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    final categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
    categoryViewModel.fetchCategories();  // Cargamos las categorías cuando se inicia el formulario
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final businessViewModel = Provider.of<BusinessViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Negocio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para el nombre del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del negocio'),
                onChanged: (value) => _name = value,
                validator: (value) => value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),

              // Campo para la descripción del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) => _description = value,
                validator: (value) => value!.isEmpty ? 'La descripción es obligatoria' : null,
              ),

              // Dropdown para seleccionar categoría
              categoryViewModel.categories.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'No hay categorías aún.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
                  : DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoría'),
                value: _selectedCategoryId.isNotEmpty ? _selectedCategoryId : null,
                items: categoryViewModel.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Debe seleccionar una categoría'
                    : null,
              ),

              // Campo para la URL de la imagen
              TextFormField(
                decoration: InputDecoration(labelText: 'URL de la imagen'),
                onChanged: (value) => _imageUrl = value,
                validator: (value) => value!.isEmpty ? 'La URL de la imagen es obligatoria' : null,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newBusiness = BusinessDTO(
                      id: '', // Se asigna al guardar en Firestore
                      name: _name,
                      description: _description,
                      categoryId: _selectedCategoryId,
                      imageUrl: _imageUrl,
                    );
                    businessViewModel.addBusiness(newBusiness);
                    Navigator.pop(context); // Cierra la pantalla
                  }
                },
                child: Text('Guardar negocio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
