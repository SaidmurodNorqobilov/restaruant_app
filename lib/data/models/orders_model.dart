class OrderModel {
  final int id;
  final int userId;
  final String status;
  final String totalPrice;
  final String paymentMethod;
  final String orderType;
  final String location;
  final String? tipTable;
  final String tip;

  OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.orderType,
    required this.location,
    this.tipTable,
    required this.tip,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      status: json['status'] as String? ?? '',
      totalPrice: json['total_price'].toString(),
      paymentMethod: json['payment_method'] as String? ?? '',
      orderType: json['order_type'] as String? ?? '',
      location: json['location'] as String? ?? '',
      tipTable: json['tip_table'] as String?,
      tip: json['tip'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'order_type': orderType,
      'location': location,
      'tip_table': tipTable,
      'tip': tip,
    };
  }
}