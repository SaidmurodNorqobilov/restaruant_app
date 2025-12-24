class CategoriesModel {
  final int id;
  final int categoryId;
  final String image;
  final String title;

  CategoriesModel({
    required this.id,
    required this.categoryId,
    required this.image,
    required this.title,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      categoryId: json['categoryId'],
      image: json['image'],
      title: json['title'],
    );
  }
}
