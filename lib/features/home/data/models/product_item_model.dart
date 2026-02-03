import 'package:hive/hive.dart';

part "product_item_model.g.dart";

@HiveType(typeId: 0)
class ProductItemModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final int vat;
  @HiveField(6)
  final String measureUnit;
  @HiveField(7)
  final int measure;
  @HiveField(8)
  final int sortOrder;
  @HiveField(9)
  final bool isActive;
  @HiveField(10)
  final String categoryId;
  @HiveField(11)
  final List<ProductModifierGroupModel> modifierGroups;
  @HiveField(12)
  final int quantity;

  ProductItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.image,
    required this.vat,
    required this.measureUnit,
    required this.measure,
    required this.sortOrder,
    required this.isActive,
    required this.categoryId,
    required this.modifierGroups,
    this.quantity = 1,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? "Tavsif yo'q",
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image'] ?? '',
      vat: json['vat'] ?? 0,
      measureUnit: json['measure_unit'] ?? '',
      measure: json['measure'] ?? 0,
      sortOrder: json['sort_order'] ?? 0,
      isActive: json['is_active'] ?? false,
      categoryId: json['category_id']?.toString() ?? '',
      modifierGroups: (json['modifier_groups'] as List<dynamic>?)
          ?.map((x) => ProductModifierGroupModel.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
      quantity: json['quantity'] ?? 1,
    );
  }

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    int? vat,
    String? measureUnit,
    int? measure,
    int? sortOrder,
    bool? isActive,
    String? categoryId,
    List<ProductModifierGroupModel>? modifierGroups,
    int? quantity,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      vat: vat ?? this.vat,
      measureUnit: measureUnit ?? this.measureUnit,
      measure: measure ?? this.measure,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      modifierGroups: modifierGroups ?? this.modifierGroups,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice {
    double modifiersPrice = 0.0;
    for (var group in modifierGroups) {
      for (var modifier in group.modifiers) {
        modifiersPrice += modifier.price;
      }
    }
    return (price + modifiersPrice) * quantity;
  }

  double get productTotalPrice => price * quantity;
}

@HiveType(typeId: 1)
class ProductModifierGroupModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int sortOrder;
  @HiveField(3)
  final int minSelectedAmount;
  @HiveField(4)
  final int maxSelectedAmount;
  @HiveField(5)
  final List<ModifiersModel> modifiers;

  ProductModifierGroupModel({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.minSelectedAmount,
    required this.maxSelectedAmount,
    required this.modifiers,
  });

  factory ProductModifierGroupModel.fromJson(Map<String, dynamic> json) {
    return ProductModifierGroupModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
      minSelectedAmount: json['min_selected_amount'] ?? 0,
      maxSelectedAmount: json['max_selected_amount'] ?? 0,
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((x) => ModifiersModel.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

@HiveType(typeId: 2)
class ModifiersModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final int maxQuantity;
  @HiveField(4)
  final int sortOrder;
  @HiveField(5)
  final String image;

  ModifiersModel({
    required this.id,
    required this.name,
    required this.price,
    required this.maxQuantity,
    required this.sortOrder,
    required this.image,
  });

  factory ModifiersModel.fromJson(Map<String, dynamic> json) {
    return ModifiersModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      maxQuantity: json['max_quantity'] ?? 0,
      sortOrder: json['sort_order'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}