import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/banner_dto.dart';
import '../manager/banner_viewmodel.dart';


class ManagerBannersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bannerViewModel = Provider.of<BannerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Banners'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Mostrar diálogo para agregar un nuevo banner
              showDialog(
                context: context,
                builder: (context) => AddEditBannerDialog(),
              );
            },
          ),
        ],
      ),
      body: bannerViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : bannerViewModel.banners.isEmpty
          ? Center(child: Text('No hay banners disponibles.'))
          : ListView.builder(
        itemCount: bannerViewModel.banners.length,
        itemBuilder: (context, index) {
          final banner = bannerViewModel.banners[index];

          return ListTile(
            leading: Image.network(
              banner.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(banner.title),
            subtitle: Text(
                banner.isActive ? 'Activo' : 'Inactivo'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: banner.isActive,
                  onChanged: (value) {
                    bannerViewModel.toggleBannerStatus(banner);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Mostrar diálogo para editar el banner
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AddEditBannerDialog(banner: banner),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(context, bannerViewModel, banner);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Confirmar eliminación de banner
  void _confirmDelete(BuildContext context, BannerViewModel viewModel, BannerDTO banner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Banner'),
        content: Text('¿Estás seguro de que deseas eliminar este banner?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteBanner(banner.id);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}


class AddEditBannerDialog extends StatefulWidget {
  final BannerDTO? banner;

  const AddEditBannerDialog({this.banner});

  @override
  _AddEditBannerDialogState createState() => _AddEditBannerDialogState();
}

class _AddEditBannerDialogState extends State<AddEditBannerDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _title = widget.banner!.title;
      _imageUrl = widget.banner!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerViewModel = Provider.of<BannerViewModel>(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value!.isEmpty ? 'El título es obligatorio' : null,
                onChanged: (value) => _title = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'URL de la imagen'),
                validator: (value) =>
                value!.isEmpty ? 'La URL de la imagen es obligatoria' : null,
                onChanged: (value) => _imageUrl = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.banner == null) {
                      // Agregar nuevo banner
                      bannerViewModel.addBanner(_title, _imageUrl);
                    } else {
                      // Editar banner existente
                      final updatedBanner = widget.banner!.copyWith(
                        title: _title,
                        imageUrl: _imageUrl,
                      );
                      bannerViewModel.updateBanner(updatedBanner);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.banner == null ? 'Agregar Banner' : 'Actualizar Banner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
