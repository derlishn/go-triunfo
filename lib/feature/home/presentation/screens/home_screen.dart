import 'package:flutter/material.dart';

void main() {
  runApp(DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoTriunfo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos de ejemplo
  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner1.png',
    'assets/images/banner1.png',
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Hamburguesa', 'icon': '🍔'},
    {'name': 'Saludable', 'icon': '🥗'},
    {'name': 'Postres', 'icon': '🍰'},
  ];

  final List<Map<String, String>> restaurants = [
    {
      'name': 'Payos Chiken',
      'image': 'assets/images/restaurant1.png',
      'rating': '4.5',
      'time': '30-40 min',
      'deliveryFee': '\$2.00',
    },
    {
      'name': 'Sushi Master',
      'image': 'assets/images/restaurant1.png',
      'rating': '4.7',
      'time': '20-30 min',
      'deliveryFee': '\$1.50',
    },
    {
      'name': 'Burger House',
      'image': 'assets/restaurant3.jpg',
      'rating': '4.3',
      'time': '25-35 min',
      'deliveryFee': '\$2.50',
    },
  ];

  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoTriunfo App', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Acción de notificaciones
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Acción de perfil de usuario
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Selector de Ubicación
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Barrio El Centro',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Acción para cambiar dirección
                    },
                    child: Text('Cambiar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),

            // Carrusel de Banners Promocionales
            Container(
              height: 180,
              child: PageView.builder(
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Indicador de banners
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: banners.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _currentBannerIndex = entry.key;
                  }),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentBannerIndex == entry.key
                          ? Colors.redAccent
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),

            // Categorías
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.redAccent,
                        child: Text(
                          categories[index]['icon']!,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(categories[index]['name']!),
                    ],
                  ).paddingSymmetric(horizontal: 12);
                },
              ),
            ),

            // Sección de Restaurantes Recomendados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Explora',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Acción de ver más
                    },
                    child: Text('Ver más',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),

            // Lista de Restaurantes
            ListView.builder(
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Índice de la pestaña actual
        onTap: (index) {
          // Manejar la navegación entre pestañas
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Extensión para agregar padding de manera más legible
extension PaddingExtension on Widget {
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value), child: this);
  }

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this);
  }
}
