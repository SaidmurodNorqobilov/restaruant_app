class PromotionsModel{
  int id;
  String title;
  double price;
  double discount;
  String img;
  String description;


  PromotionsModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.img,
    required this.description,
  });

  factory PromotionsModel.fromJson(Map<String, dynamic> json) {
    return PromotionsModel(
      id: json['id'],
      title: json['title'],
      price: json['price'] as double,
      discount: json['discount'] as double,
      img: json['img'],
      description: json['description'],
    );
  }
}