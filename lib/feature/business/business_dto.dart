import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessDTO {
  final String id;
  final String name;
  final DateTime createdAt;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String address;
  final String businessPhone;
  final String imageUrl;
  final int totalProducts;
  final int ordersToday;
  final Map<String, int> weeklyOrders; // Pedidos semanales
  final Map<String, int> monthlyOrders; // Pedidos mensuales
  final bool isActive;
  final double? ranking;
  final String categoryId;
  final String? description;

  // Constructor
  BusinessDTO({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.address,
    required this.businessPhone,
    required this.imageUrl,
    required this.totalProducts,
    required this.ordersToday,
    required this.weeklyOrders,
    required this.monthlyOrders,
    required this.isActive,
    this.ranking,
    required this.categoryId,
    this.description,
  });

  // Método para crear una instancia desde JSON
  factory BusinessDTO.fromJson(Map<String, dynamic> json, String documentId) {
    return BusinessDTO(
      id: documentId,
      name: json['name'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      ownerName: json['ownerName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      address: json['address'] ?? '',
      businessPhone: json['businessPhone'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      totalProducts: json['totalProducts'] ?? 0,
      ordersToday: json['ordersToday'] ?? 0,
      weeklyOrders: Map<String, int>.from(json['weeklyOrders'] ?? {}),
      monthlyOrders: Map<String, int>.from(json['monthlyOrders'] ?? {}),
      isActive: json['isActive'] ?? true,
      ranking:
          json['ranking'] != null ? (json['ranking'] as num).toDouble() : null,
      categoryId: json['categoryId'] ?? '',
      description: json['description'],
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'address': address,
      'businessPhone': businessPhone,
      'imageUrl': imageUrl,
      'totalProducts': totalProducts,
      'ordersToday': ordersToday,
      'weeklyOrders': weeklyOrders,
      'monthlyOrders': monthlyOrders,
      'isActive': isActive,
      'ranking': ranking,
      'categoryId': categoryId,
      'description': description,
    };
  }

  // Método copyWith para actualizar campos
  BusinessDTO copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    String? address,
    String? businessPhone,
    String? imageUrl,
    int? totalProducts,
    int? ordersToday,
    Map<String, int>? weeklyOrders,
    Map<String, int>? monthlyOrders,
    bool? isActive,
    double? ranking,
    String? categoryId,
    String? description,
  }) {
    return BusinessDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      address: address ?? this.address,
      businessPhone: businessPhone ?? this.businessPhone,
      imageUrl: imageUrl ?? this.imageUrl,
      totalProducts: totalProducts ?? this.totalProducts,
      ordersToday: ordersToday ?? this.ordersToday,
      weeklyOrders: weeklyOrders ?? this.weeklyOrders,
      monthlyOrders: monthlyOrders ?? this.monthlyOrders,
      isActive: isActive ?? this.isActive,
      ranking: ranking ?? this.ranking,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
    );
  }

  // Método para actualizar los pedidos mensuales
  void updateMonthlyOrders(DateTime date) {
    final monthYear = '${date.month}-${date.year}';
    if (monthlyOrders.containsKey(monthYear)) {
      monthlyOrders[monthYear] = monthlyOrders[monthYear]! + 1;
    } else {
      monthlyOrders[monthYear] = 1;
    }
  }

  // Método para actualizar los pedidos semanales
  void updateWeeklyOrders(DateTime date) {
    final weekYear = '${_getWeekOfYear(date)}-${date.year}';
    if (weeklyOrders.containsKey(weekYear)) {
      weeklyOrders[weekYear] = weeklyOrders[weekYear]! + 1;
    } else {
      weeklyOrders[weekYear] = 1;
    }
  }

  // Método para obtener el número de la semana del año
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    return (daysPassed / 7).ceil();
  }
}
