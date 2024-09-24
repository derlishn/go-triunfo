import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/category_dto.dart';
import '../category_viewmodel.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryDTO category;

  EditCategoryDialog({required this.category});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _icon;

  @override
  void initState() {
    super.initState();
    _name = widget.category.name;
    _icon = widget.category.icon ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return AlertDialog(
      title: Text('Editar Categoría'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Nombre de la categoría'),
              validator: (value) =>
              value!.isEmpty ? 'El nombre es obligatorio' : null,
              onChanged: (value) => _name = value,
            ),
            TextFormField(
              initialValue: _icon,
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
              final updatedCategory = widget.category.copyWith(
                name: _name,
                icon: _icon.isNotEmpty ? _icon : null,
              );
              categoryViewModel.updateCategory(updatedCategory);
              Navigator.of(context).pop();
            }
          },
          child: Text('Actualizar'),
        ),
      ],
    );
  }
}
