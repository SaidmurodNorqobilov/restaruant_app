import 'dart:io';

class UserProfileModel {
  final int id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? status;
  final String coinBalance;
  final String? createdAt;
  final String? updatedAt;

  UserProfileModel({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.status,
    required this.coinBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      phone: json['phone'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      status: json['status'],
      coinBalance: json['coin_balance'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class UserProfilePostModel {
  final String firstName;
  final String lastName;
  final File? imageFile;

  UserProfilePostModel({
    required this.firstName,
    required this.lastName,
    this.imageFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}