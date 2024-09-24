import 'package:flutter/material.dart';
import 'package:go_triunfo/core/utils/helpers/navigator_helper.dart';
import 'package:go_triunfo/feature/business/business_form_screen.dart';
import 'package:provider/provider.dart';

import 'business_viewmodel.dart';

class BusinessListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<BusinessViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Negocios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              navigateTo(context, BusinessFormScreen());
            },
          ),
        ],
      ),
      body: businessViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: businessViewModel.businesses.length,
        itemBuilder: (context, index) {
          final business = businessViewModel.businesses[index];
          return ListTile(
            title: Text(business.name),
            subtitle: Text(business.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                businessViewModel.deleteBusiness(business.id);
              },
            ),
          );
        },
      ),
    );
  }
}
