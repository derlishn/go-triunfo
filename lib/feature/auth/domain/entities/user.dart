class User {
  final String uid;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? address;
  final String? photoUrl; // Se maneja el photoUrl como opcional
  final DateTime createdAt;
  final String role; // Role of the user: client, admin, etc.
  final String accountStatus; // Account status: active, suspended, etc.
  final String gender; // Gender field added
  final int orders; // Número de órdenes, inicialmente 0

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.address,
    this.photoUrl,
    required this.createdAt,
    this.role = 'client',
    this.accountStatus = 'active',
    this.gender = 'not specified', // Valor por defecto
    this.orders = 0, // Inicialmente 0 órdenes
  });

  // CopyWith method to facilitate updating specific fields
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
    String? role,
    String? accountStatus,
    String? gender,
    int? orders,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      accountStatus: accountStatus ?? this.accountStatus,
      gender: gender ?? this.gender,
      orders: orders ?? this.orders,
    );
  }
}
