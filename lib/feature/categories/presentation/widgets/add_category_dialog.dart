import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../category_viewmodel.dart';


class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _icon = '';

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return AlertDialog(
      title: Text('Agregar Categoría'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre de la categoría'),
              validator: (value) =>
              value!.isEmpty ? 'El nombre es obligatorio' : null,
              onChanged: (value) => _name = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Ícono de la categoría'),
              onChanged: (value) => _icon = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              categoryViewModel.addCategory(_name, icon: _icon.isNotEmpty ? _icon : null);
              Navigator.of(context).pop();
            }
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }
}
