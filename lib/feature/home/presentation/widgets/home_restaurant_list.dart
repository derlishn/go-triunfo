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
          return const Center(child: CircularProgressIndicator()); 
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay restaurantes disponibles.')); // Mensaje si no hay datos
        }

        final restaurants = snapshot.data!.docs;

        return SizedBox(
          height: 280, // Altura ajustada para las tarjetas más grandes
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Mover los restaurantes en horizontal
            itemCount: restaurants.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final restaurantData = restaurants[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  // Acción al tocar la tarjeta del restaurante
                  print('Restaurante ${restaurantData['name']} seleccionado');
                },
                child: Container(
                  width: 280, // Ancho de la tarjeta más grande
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del restaurante con bordes redondeados en la parte superior
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            restaurantData['imageUrl'] ?? 'https://via.placeholder.com/300',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Detalles del restaurante
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurantData['name'] ?? 'Restaurante sin nombre',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    '4.6',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ), // Puntuación ficticia
                                  SizedBox(width: 20),
                                  Icon(Icons.timer, size: 18, color: Colors.black54),
                                  SizedBox(width: 6),
                                  Text(
                                    '20 min',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ), // Tiempo ficticio
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Comisión: Lps 30', // Comisión ficticia
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
