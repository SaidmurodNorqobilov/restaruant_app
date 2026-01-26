class CartModel {
  final int id;
  final int orderId;
  final CartProduct product;
  final int quantity;
  final double price;

  CartModel({
    required this.id,
    required this.orderId,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      product: CartProduct.fromJson(json['product_id'] ?? {}),
      quantity: json['quantity'] ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class CartProduct {
  final int id;
  final String name;
  final String? image;

  CartProduct({
    required this.id,
    required this.name,
    this.image,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      image: json['image'],
    );
  }
}