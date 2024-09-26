import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRestaurantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('businesses')
          .where('isActive', isEqualTo: true) // Solo negocios activos
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Indicador de carga
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay restaurantes disponibles.')); // Mensaje si no hay datos
        }

        final restaurants = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: restaurants.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final restaurantData = restaurants[index].data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Imagen del restaurante
                  Image.network(
                    restaurantData['imageUrl'] ?? 'https://via.placeholder.com/150',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(restaurantData['name'] ?? 'Restaurante sin nombre'),
                    subtitle: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(restaurantData['rating']?.toString() ?? '0.0'),
                        SizedBox(width: 16),
                        Icon(Icons.timer, size: 16),
                        SizedBox(width: 4),
                        Text(restaurantData['time'] ?? 'Tiempo desconocido'),
                      ],
                    ),
                    trailing: Text(
                      restaurantData['deliveryFee'] != null
                          ? '\$${restaurantData['deliveryFee']}'
                          : 'Sin tarifa',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
