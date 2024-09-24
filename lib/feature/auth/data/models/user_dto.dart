import 'package:cloud_firestore/cloud_firestore.dart';

class UserDTO {
  final String uid;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? address;
  final String? photoUrl;
  final DateTime createdAt;
  final String role;
  final String gender;
  final int orders;

  UserDTO({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.address,
    this.photoUrl,
    required this.createdAt,
    required this.role,
    required this.gender,
    required this.orders,
  });

  factory UserDTO.fromMap(Map<String, dynamic> data) {
    return UserDTO(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      role: data['role'] ?? 'cliente',
      gender: data['gender'] ?? 'no especificado',
      orders: data['orders'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'role': role,
      'gender': gender,
      'orders': orders,
    };
  }

  UserDTO copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? address,
    String? photoUrl,
    DateTime? createdAt,
    String? role,
    String? gender,
    int? orders,
  }) {
    return UserDTO(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      orders: orders ?? this.orders,
    );
  }
}
