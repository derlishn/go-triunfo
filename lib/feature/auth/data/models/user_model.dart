import 'package:go_triunfo/feature/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String uid,
    required String email,
    required String displayName,
    String? phoneNumber,
    String? address,
    String? photoUrl, // Optional photoUrl
    required DateTime createdAt,
    required String role,
    required String accountStatus,
    required String gender, // Added gender field
    int orders = 0, // Orders initialized at 0
  }) : super(
    uid: uid,
    email: email,
    displayName: displayName,
    phoneNumber: phoneNumber,
    address: address,
    photoUrl: photoUrl ?? 'https://defaulturl.com/default-photo.png', // Default photo URL if not provided
    createdAt: createdAt,
    role: role,
    accountStatus: accountStatus,
    gender: gender,
    orders: orders,
  );

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
      'accountStatus': accountStatus,
      'gender': gender,
      'orders': orders,
    };
  }

  // Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      role: json['role'],
      accountStatus: json['accountStatus'],
      gender: json['gender'],
      orders: json['orders'] ?? 0, // Default to 0 if not present
    );
  }

  // CopyWith method to update specific fields
  UserModel copyWith({
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
    return UserModel(
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
