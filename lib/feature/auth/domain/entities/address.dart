class Address {
  final String location;

  Address({
    required this.location,
  });

  Address copyWith({
    String? location,
  }) {
    return Address(
      location: location ?? this.location,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
    };
  }

  @override
  String toString() => 'Address(location: $location)'; // Para depuración y logs
}
