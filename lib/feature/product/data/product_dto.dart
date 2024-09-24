class ProductDTO {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String ownerId;
  final int stock;
  final double rating;

  ProductDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.ownerId,
    required this.stock,
    required this.rating,
  });

  // Convertir a mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'ownerId': ownerId,
      'stock': stock,
      'rating': rating,
    };
  }

  // Crear un objeto `ProductDTO` desde Firestore
  factory ProductDTO.fromMap(Map<String, dynamic> data) {
    return ProductDTO(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      categoryId: data['categoryId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      stock: data['stock'] ?? 0,
      rating: data['rating'] ?? 0.0,
    );
  }
}
