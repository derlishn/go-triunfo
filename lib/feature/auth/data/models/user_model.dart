import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:go_triunfo/feature/auth/domain/entities/user.dart';

import '../../domain/entities/enums.dart';

class UserModel extends User {
  UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.phoneNumber,
    super.address, // Asegúrate de que 'address' existe en la entidad User
    super.photoUrl,
    required DateTime super.createdAt,
    super.role,
    super.gender,
    super.orders,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName ?? 'Usuario desconocido',
      phoneNumber: firebaseUser.phoneNumber ?? '',
      // Firebase User no contiene un campo 'address', quítalo si no lo necesitas o maneja un valor por defecto
      address: null, // Si quieres manejar una dirección, podrías gestionarla aparte
      photoUrl: firebaseUser.photoURL ?? '',
      createdAt: DateTime.now(),
      // Aquí puedes manejar el rol y género si es necesario
      role: UserRole.client, // Asigna un valor por defecto si no hay información
      gender: Gender.notSpecified, // Asigna un valor por defecto si no hay información
      orders: 0, // Valor por defecto
    );
  }

  // Si necesitas una conversión desde JSON para 'address', añade una lógica similar aquí
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'], // Asegúrate de que 'address' esté correctamente manejado
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.' + json['role']),
      gender: Gender.values.firstWhere((e) => e.toString() == 'Gender.' + json['gender']),
      orders: json['orders'],
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address, // Si address está presente, manejarlo aquí
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'role': role.toString().split('.').last,
      'gender': gender.toString().split('.').last,
      'orders': orders,
    };
  }
}
