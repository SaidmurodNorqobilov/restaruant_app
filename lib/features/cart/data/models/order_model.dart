// class OrderModel {
//   final String orderType;
//   final String paymentProvider;
//   final String paymentMethod;
//   final String address;
//   final String locationId;
//   final List<OrderProductsModel> products;
//   final List<OrderModifierModel> modifiers;
//
//   OrderModel({
//     required this.orderType,
//     required this.paymentProvider,
//     required this.paymentMethod,
//     required this.address,
//     required this.locationId,
//     required this.products,
//     required this.modifiers,
//   });
//
//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       orderType: json['order_type'] ?? '',
//       paymentProvider: json['payment_provider'] ?? '',
//       paymentMethod: json['payment_method'] ?? '',
//       address: json['address'] ?? '',
//       locationId: json['location_id']?.toString() ?? '',
//       products: (json['products'] as List?)
//           ?.map((x) => OrderProductsModel.fromJson(x)),
//       modifiers: (json['modifiers'] as List?)
//           ?.map((x) => OrderModifierModel.fromJson(x)),
//     );
//   }
// }
//
// class OrderProductsModel {
//   final String id;
//   final int quantity;
//
//   OrderProductsModel({
//     required this.id,
//     required this.quantity,
//   });
//
//   factory OrderProductsModel.fromJson(Map<String, dynamic> json) {
//     return OrderProductsModel(
//       id: json['product_id']?.toString() ?? '',
//       quantity: json['quantity'] ?? 0,
//     );
//   }
// }
//
// class OrderModifierModel {
//   final String id;
//   final int quantity;
//
//   OrderModifierModel({required this.id, required this.quantity});
//
//   factory OrderModifierModel.fromJson(Map<String, dynamic> json) {
//     return OrderModifierModel(
//       id: json['modifier_id']?.toString() ?? '',
//       quantity: json['quantity'] ?? 0,
//     );
//   }
// }
