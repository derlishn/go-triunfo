import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../categories/presentation/category_viewmodel.dart';
import 'business_viewmodel.dart';

class AddBusinessScreen extends StatefulWidget {
  @override
  _AddBusinessScreenState createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _ownerName = '';
  String _ownerEmail = '';
  String _ownerPhone = '';
  String _address = '';
  String _businessPhone = '';
  String _imageUrl = '';
  String? _description;
  String _selectedCategoryId = '';

  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<BusinessViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Negocio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de nombre del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del negocio'),
                onChanged: (value) => _name = value,
                validator: (value) => value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              // Campo de nombre del dueño
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del dueño'),
                onChanged: (value) => _ownerName = value,
                validator: (value) => value!.isEmpty ? 'El nombre del dueño es obligatorio' : null,
              ),
              // Campo de correo del dueño
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo del dueño'),
                onChanged: (value) => _ownerEmail = value,
                validator: (value) => value!.isEmpty ? 'El correo es obligatorio' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              // Campo de teléfono del dueño
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono del dueño'),
                onChanged: (value) => _ownerPhone = value,
                validator: (value) => value!.isEmpty ? 'El teléfono es obligatorio' : null,
                keyboardType: TextInputType.phone,
              ),
              // Campo de dirección del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección física del negocio'),
                onChanged: (value) => _address = value,
                validator: (value) => value!.isEmpty ? 'La dirección es obligatoria' : null,
              ),
              // Campo de teléfono del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono del negocio'),
                onChanged: (value) => _businessPhone = value,
                validator: (value) => value!.isEmpty ? 'El teléfono del negocio es obligatorio' : null,
                keyboardType: TextInputType.phone,
              ),
              // Campo de URL de la imagen del negocio
              TextFormField(
                decoration: InputDecoration(labelText: 'URL de la imagen'),
                onChanged: (value) => _imageUrl = value,
                validator: (value) => value!.isEmpty ? 'La URL de la imagen es obligatoria' : null,
              ),
              // Campo opcional de descripción
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción (Opcional)'),
                onChanged: (value) => _description = value,
              ),
              // Dropdown para seleccionar categoría
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoría'),
                value: _selectedCategoryId.isNotEmpty ? _selectedCategoryId : null,
                items: categoryViewModel.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400) ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
                validator: (value) => value == null ? 'Debe seleccionar una categoría' : null,
              ),
              SizedBox(height: 20),
              // Botón para enviar el formulario
              ElevatedButton(
                onPressed: _submitForm,
                child: businessViewModel.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Guardar negocio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final businessViewModel = Provider.of<BusinessViewModel>(context, listen: false);

      // Llamamos al método en el ViewModel
      businessViewModel.addBusiness(
        name: _name,
        ownerName: _ownerName,
        ownerEmail: _ownerEmail,
        ownerPhone: _ownerPhone,
        address: _address,
        businessPhone: _businessPhone,
        imageUrl: _imageUrl,
        categoryId: _selectedCategoryId,
        description: _description,
      ).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al agregar negocio: $error'),
        ));
      });
    }
  }
}
