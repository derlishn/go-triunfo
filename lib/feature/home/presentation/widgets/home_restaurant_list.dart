import 'package:flutter/material.dart';

class HomeRestaurantList extends StatelessWidget {
  // Ejemplo de restaurantes, pueden venir de una API o Firebase
  final List<Map<String, String>> restaurants = [
    {
      'name': 'Payos Chicken',
      'image': 'assets/images/restaurant1.png',
      'rating': '4.5',
      'time': '30-40 min',
      'deliveryFee': '\$2.00',
    },
    {
      'name': 'Sushi Master',
      'image': 'assets/images/restaurant2.png',
      'rating': '4.7',
      'time': '20-30 min',
      'deliveryFee': '\$1.50',
    },
    {
      'name': 'Burger House',
      'image': 'assets/images/restaurant3.png',
      'rating': '4.3',
      'time': '25-35 min',
      'deliveryFee': '\$2.50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Image.asset(
                restaurants[index]['image']!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(restaurants[index]['name']!),
                subtitle: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(restaurants[index]['rating']!),
                    SizedBox(width: 16),
                    Icon(Icons.timer, size: 16),
                    SizedBox(width: 4),
                    Text(restaurants[index]['time']!),
                  ],
                ),
                trailing: Text(
                  restaurants[index]['deliveryFee']!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
