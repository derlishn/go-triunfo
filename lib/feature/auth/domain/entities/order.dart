import 'enums.dart';

class Order {
  final String orderId;
  final DateTime orderDate;
  final double totalAmount;
  final DeliveryStatus status;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    this.status = DeliveryStatus.inProcess,
  });

  Order copyWith({
    String? orderId,
    DateTime? orderDate,
    double? totalAmount,
    DeliveryStatus? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
