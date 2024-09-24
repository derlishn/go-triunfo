class BusinessDTO {
  final String id;
  final String name;
  final String description;
  final String categoryId; // Relación con la categoría
  final String imageUrl;

  BusinessDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.imageUrl,
  });

  // Método copyWith para crear un nuevo objeto con cambios específicos
  BusinessDTO copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    String? imageUrl,
  }) {
    return BusinessDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convertir el modelo a un Map para almacenarlo en Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
    };
  }

  // Crear el modelo a partir de un Map (desde Firebase)
  factory BusinessDTO.fromMap(Map<String, dynamic> map) {
    return BusinessDTO(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      categoryId: map['categoryId'],
      imageUrl: map['imageUrl'],
    );
  }
}
