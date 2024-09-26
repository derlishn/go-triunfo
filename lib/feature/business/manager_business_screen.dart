import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/business/add_business_screen.dart';
import 'package:go_triunfo/feature/business/edit_business_screen.dart';
import 'package:provider/provider.dart';
import 'business_dto.dart';
import 'business_viewmodel.dart';

class ManagerBusinessScreen extends StatefulWidget {
  @override
  _ManagerBusinessScreenState createState() => _ManagerBusinessScreenState();
}

class _ManagerBusinessScreenState extends State<ManagerBusinessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final businessViewModel = Provider.of<BusinessViewModel>(context, listen: true);
      businessViewModel.fetchAllBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<BusinessViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Negocios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              navigateTo(context, AddBusinessScreen());
            },
          ),
        ],
      ),
      body: businessViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : businessViewModel.businesses.isEmpty
          ? Center(child: Text('No hay negocios disponibles.'))
          : ListView.builder(
        itemCount: businessViewModel.businesses.length,
        itemBuilder: (context, index) {
          final business = businessViewModel.businesses[index];
          return BusinessCard(business: business, viewModel: businessViewModel);
        },
      ),
    );
  }
}

class BusinessCard extends StatefulWidget {
  final BusinessDTO business;
  final BusinessViewModel viewModel;

  const BusinessCard({required this.business, required this.viewModel});

  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final business = widget.business;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(business.imageUrl),
            ),
            title: Text(business.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Propietario: ${business.ownerName}'),
                Text('Teléfono: ${business.businessPhone}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  navigateTo(context, EditBusinessScreen(business: business));
                } else if (value == 'delete') {
                  _confirmDelete(context, widget.viewModel, business.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_vert),
            ),
          ),
          if (_isExpanded) _buildExpandedInfo(business),
          _buildActionRow(business),
        ],
      ),
    );
  }

  Widget _buildExpandedInfo(BusinessDTO business) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dirección: ${business.address}', style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 4),
          Text('Pedidos hoy: ${business.ordersToday}', style: TextStyle(color: Colors.grey[600])),
          Text('Pedidos esta semana: ${business.weeklyOrders}', style: TextStyle(color: Colors.grey[600])),
          Text('Pedidos este mes: ${business.monthlyOrders}', style: TextStyle(color: Colors.grey[600])),
          if (business.description != null) ...[
            SizedBox(height: 4),
            Text('Descripción: ${business.description}', style: TextStyle(color: Colors.grey[600])),
          ],
        ],
      ),
    );
  }

  Widget _buildActionRow(BusinessDTO business) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? 'Ver menos' : 'Ver más'),
          ),
          Row(
            children: [
              Switch(
                value: business.isActive,
                onChanged: (value) async {
                  await widget.viewModel.toggleBusinessStatus(business.id, value);
                  widget.viewModel.fetchAllBusinesses(); // Refrescar la lista después del cambio de estado
                },
              ),
              Text(business.isActive ? 'Activo' : 'Inactivo'),
            ],
          ),
        ],
      ),
    );
  }

  // Confirmar eliminación de negocio
  void _confirmDelete(BuildContext context, BusinessViewModel viewModel, String businessId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Negocio'),
        content: Text('¿Estás seguro de que deseas eliminar este negocio?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.deleteBusiness(businessId);
              Navigator.of(context).pop();
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
