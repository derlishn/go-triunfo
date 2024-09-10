class Order {
  final String orderId;
  final DateTime orderDate;
  final double totalAmount;
  final String status; // Order status: in_process, delivered, canceled, etc.

  Order({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    this.status = 'in_process',
  });

  // CopyWith method to update specific fields
  Order copyWith({
    String? orderId,
    DateTime? orderDate,
    double? totalAmount,
    String? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
