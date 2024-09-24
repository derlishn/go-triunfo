class CategoryDTO {
  final String id;
  final String name;
  final String? icon;
  final bool isActive; // Nuevo campo para manejar si la categoría está activa o no

  // Constructor
  CategoryDTO({
    required this.id,
    required this.name,
    this.icon,
    this.isActive = true, // Por defecto, la categoría está activa
  });

  // Método para crear una instancia de CategoryDTO desde un JSON (Firebase).
  factory CategoryDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return CategoryDTO(
      id: documentId,
      name: json['name'] ?? 'Sin nombre',
      icon: json['icon'], // icono opcional
      isActive: json['isActive'] ?? true, // Si no se proporciona, está activo
    );
  }

  // Método para convertir una instancia de CategoryDTO a un JSON (para enviar a Firebase).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'isActive': isActive, // Agregar estado de actividad al JSON
    };
  }

  // Método para copiar y actualizar una instancia de CategoryDTO
  CategoryDTO copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isActive,
  }) {
    return CategoryDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive, // Actualizar estado de actividad
    );
  }
}
