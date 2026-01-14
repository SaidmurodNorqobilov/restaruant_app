class OrderModel {
  final int id;
  final int orderNumber;
  final int orderId;
  final String name;
  final String location;
  final double total;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderId,
    required this.name,
    required this.location,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      orderId: json['order_id'],
      name: json['name'],
      location: json['location'],
      total: json['total'].toDouble(),
    );
  }
}