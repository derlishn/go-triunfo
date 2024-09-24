class BannerDTO {
  final String id;
  final String title;
  final String imageUrl;
  final bool isActive;

  BannerDTO({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isActive = true,
  });

  // Convertir desde JSON
  factory BannerDTO.fromJson(Map<String, dynamic> json, String id) {
    return BannerDTO(
      id: id,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  // Método para copiar y actualizar campos (copyWith)
  BannerDTO copyWith({
    String? title,
    String? imageUrl,
    bool? isActive,
  }) {
    return BannerDTO(
      id: this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
