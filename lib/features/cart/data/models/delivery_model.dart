class DeliveryModel {
  final int id;
  final String deliveryPrice;
  final String freeDeliveryThreshold;

  DeliveryModel({
    required this.id,
    required this.deliveryPrice,
    required this.freeDeliveryThreshold,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as int,
      deliveryPrice: json['delivery_price'].toString(),
      freeDeliveryThreshold: json['free_delivery_threshold'].toString(),
    );
  }
}