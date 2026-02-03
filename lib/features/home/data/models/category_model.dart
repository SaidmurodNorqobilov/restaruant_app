class CategoryModel {
  final String id;
  final String image;
  final String name;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}

class ProductModel {
  final List<ProductModelItem> productItem;
  final int total;
  final int page;
  final int limit;
  final int totalPage;

  ProductModel({
    required this.productItem,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productItem:
          (json['products'] as List?)
              ?.map((x) => ProductModelItem.fromJson(x))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPage: json['total_pages'] ?? 1,
    );
  }
}

class ProductModelItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int vat;
  final String measureUnit;
  final int measure;
  final int sortOrder;
  final bool isActive;
  final String categoryId;
  final int coin;

  ProductModelItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.vat,
    required this.measureUnit,
    required this.measure,
    required this.sortOrder,
    required this.isActive,
    required this.categoryId,
    required this.coin,
  });

  factory ProductModelItem.fromJson(Map<String, dynamic> json) {
    return ProductModelItem(
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
      coin: json['coin_price'] ?? 0,
    );
  }
}
