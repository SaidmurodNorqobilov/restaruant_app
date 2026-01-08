import 'dart:io';

class UserProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;
  final String phone;
  final String address;

  UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.phone,
    required this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image'];

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('/media')) {
      imageUrl = "https://atsrestaurant.pythonanywhere.com$imageUrl";
    }

    return UserProfileModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: imageUrl,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image': image,
      'phone': phone,
      'address': address,
    };
  }
}

class UserProfilePostModel {
  final String firstName;
  final String lastName;
  final File? imageFile;
  final String address;

  UserProfilePostModel({
    required this.firstName,
    required this.lastName,
    this.imageFile,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
    };
  }
}
