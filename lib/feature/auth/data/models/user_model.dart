import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.gender,
    required super.role,
    required super.isActive,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      gender: json['gender'],
      role: json['role'],
      isActive: json['isActive'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'gender': gender,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
