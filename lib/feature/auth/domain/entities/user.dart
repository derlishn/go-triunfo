import 'address.dart';
import 'enums.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final Address? address;
  final String? photoUrl;
  final DateTime createdAt;
  final UserRole role;
  final Gender gender;
  final int orders;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.address,
    this.photoUrl,
    DateTime? createdAt,
    this.role = UserRole.client,
    this.gender = Gender.notSpecified,
    this.orders = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    Address? address,
    String? photoUrl,
    DateTime? createdAt,
    UserRole? role,
    Gender? gender,
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
      gender: gender ?? this.gender,
      orders: orders ?? this.orders,
    );
  }
}
