class ProductModel {
  final int id;
  final String image;
  final String title;

  ProductModel({
    required this.id,
    required this.image,
    required this.title,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      image: json['image'],
      title: json['title'],
    );
  }
}
