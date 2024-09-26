import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../categories/presentation/category_viewmodel.dart';
import 'business_viewmodel.dart';
import 'business_dto.dart';

class EditBusinessScreen extends StatefulWidget {
  final BusinessDTO business;

  EditBusinessScreen({required this.business});

  @override
  _EditBusinessScreenState createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _ownerName;
  late String _ownerEmail;
  late String _ownerPhone;
  late String _address;
  late String _businessPhone;
  late String _imageUrl;
  late String? _description;
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();

    // Inicializar con los datos del negocio
    _name = widget.business.name;
    _ownerName = widget.business.ownerName;
    _ownerEmail = widget.business.ownerEmail;
    _ownerPhone = widget.business.ownerPhone;
    _address = widget.business.address;
    _businessPhone = widget.business.businessPhone;
    _imageUrl = widget.business.imageUrl;
    _description = widget.business.description;
    _selectedCategoryId = widget.business.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<BusinessViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Negocio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de nombre del negocio
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nombre del negocio'),
                onChanged: (value) => _name = value,
                validator: (value) => value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              // Campo de nombre del dueño
              TextFormField(
                initialValue: _ownerName,
                decoration: InputDecoration(labelText: 'Nombre del dueño'),
                onChanged: (value) => _ownerName = value,
                validator: (value) => value!.isEmpty ? 'El nombre del dueño es obligatorio' : null,
              ),
              // Campo de correo del dueño
              TextFormField(
                initialValue: _ownerEmail,
                decoration: InputDecoration(labelText: 'Correo del dueño'),
                onChanged: (value) => _ownerEmail = value,
                validator: (value) => value!.isEmpty ? 'El correo es obligatorio' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              // Campo de teléfono del dueño
              TextFormField(
                initialValue: _ownerPhone,
                decoration: InputDecoration(labelText: 'Teléfono del dueño'),
                onChanged: (value) => _ownerPhone = value,
                validator: (value) => value!.isEmpty ? 'El teléfono es obligatorio' : null,
                keyboardType: TextInputType.phone,
              ),
              // Campo de dirección del negocio
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: 'Dirección física del negocio'),
                onChanged: (value) => _address = value,
                validator: (value) => value!.isEmpty ? 'La dirección es obligatoria' : null,
              ),
              // Campo de teléfono del negocio
              TextFormField(
                initialValue: _businessPhone,
                decoration: InputDecoration(labelText: 'Teléfono del negocio'),
                onChanged: (value) => _businessPhone = value,
                validator: (value) => value!.isEmpty ? 'El teléfono del negocio es obligatorio' : null,
                keyboardType: TextInputType.phone,
              ),
              // Campo de URL de la imagen del negocio
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'URL de la imagen'),
                onChanged: (value) => _imageUrl = value,
                validator: (value) => value!.isEmpty ? 'La URL de la imagen es obligatoria' : null,
              ),
              // Campo opcional de descripción
              TextFormField(
                initialValue: _description,
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
                    child: Text(category.name),
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
                    : Text('Actualizar negocio'),
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

      // Llamamos al método en el ViewModel para actualizar
      businessViewModel.updateBusiness(
        BusinessDTO(
          id: widget.business.id, // Mantener el mismo ID
          name: _name,
          ownerName: _ownerName,
          ownerEmail: _ownerEmail,
          ownerPhone: _ownerPhone,
          address: _address,
          businessPhone: _businessPhone,
          imageUrl: _imageUrl,
          categoryId: _selectedCategoryId,
          isActive: widget.business.isActive, // Mantener el estado actual (activo/inactivo)
          ordersToday: widget.business.ordersToday, // Mantener los pedidos de hoy
          createdAt: widget.business.createdAt, // Mantener la fecha de creación original
          monthlyOrders: widget.business.monthlyOrders, // Mantener los pedidos mensuales
          weeklyOrders: widget.business.weeklyOrders, // Mantener los pedidos semanales
          totalProducts: widget.business.totalProducts, // Mantener el número total de productos
          description: _description, // Actualizar la descripción si es necesario
          ranking: widget.business.ranking, // Mantener el ranking actual
        ),
      ).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar negocio: $error'),
        ));
      });
    }
  }
}
