class CategoryModel {
  final int id;
  final String image;
  final String name;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ProductModel {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final String image;
  final double vat;
  final double basePrice;
  final double finalPrice;
  final int discount;
  final bool isStock;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.image,
    required this.vat,
    required this.basePrice,
    required this.finalPrice,
    required this.discount,
    required this.isStock,
    required this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      categoryId: json['category'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      vat: double.tryParse(json['vat']?.toString() ?? '0') ?? 0.0,
      basePrice: double.tryParse(json['base_price']?.toString() ?? '0') ?? 0.0,
      finalPrice: double.tryParse(json['final_price']?.toString() ?? '0') ?? 0.0,
      discount: json['discount'] ?? 0,
      isStock: json['is_stock'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}