class OrderModel {
  final String id;
  final int userId;
  final String? orderNumber;
  final String usedCoins;
  final String cashAmount;
  final String earnedCoins;
  final String totalPrice;
  final String itemsPrice;
  final String deliveryFee;
  final String status;
  final String orderType;
  final String paymentMethod;
  final String paymentStatus;
  final String address;
  final String customerPhone;
  final String locationId;
  final String lat;
  final String lng;
  final LocationModel? location;
  final List<OrderItemsModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    this.orderNumber,
    required this.usedCoins,
    required this.cashAmount,
    required this.earnedCoins,
    required this.totalPrice,
    required this.itemsPrice,
    required this.deliveryFee,
    required this.status,
    required this.orderType,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.address,
    required this.customerPhone,
    required this.locationId,
    required this.lat,
    required this.lng,
    this.location,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      orderNumber: json['order_number'],
      usedCoins: json['used_coins'] ?? '0',
      cashAmount: json['cash_amount'] ?? '0',
      earnedCoins: json['earned_coins'] ?? '0',
      totalPrice: json['total_price'] ?? '0',
      itemsPrice: json['items_price'] ?? '0',
      deliveryFee: json['delivery_fee'] ?? '0',
      status: json['status'] ?? 'NEW',
      orderType: json['order_type'] ?? 'DELIVERY',
      paymentMethod: json['payment_method'] ?? 'PAYMENT_CASH',
      paymentStatus: json['payment_status'] ?? 'PENDING',
      address: json['address'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      locationId: json['location_id'] ?? '',
      lat: json['lat'] ?? '0',
      lng: json['lng'] ?? '0',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItemsModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'used_coins': usedCoins,
      'cash_amount': cashAmount,
      'earned_coins': earnedCoins,
      'total_price': totalPrice,
      'items_price': itemsPrice,
      'delivery_fee': deliveryFee,
      'status': status,
      'order_type': orderType,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'address': address,
      'customer_phone': customerPhone,
      'location_id': locationId,
      'lat': lat,
      'lng': lng,
      'location': location?.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class LocationModel {
  final String id;
  final int userId;
  final String title;
  final String addressLine;
  final String latitude;
  final String longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  LocationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      addressLine: json['address_line'] ?? '',
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'address_line': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class OrderItemsModel {
  final int id;
  final String orderId;
  final String productId;
  final String productName;
  final int quantity;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItemsModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItemsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemsModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? '0',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}