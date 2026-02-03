import 'dart:io';
import 'package:dio/dio.dart';
import 'package:restaurantapp/features/accaunt/data/models/user_profile_model.dart';
import '../../../../core/network/client.dart';
import '../../../../core/error/result.dart';

class ProfileRepository {
  final ApiClient _client;

  ProfileRepository({required ApiClient client}) : _client = client;

  Future<Result<UserProfileModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    try {
      final formData = await _createFormData(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        imageFile: imageFile,
      );

      final response = await _client.dio.patch(
        '/accounts/update_my_profile/',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = UserProfileModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Result.ok(user);
      } else {
        final errorData = response.data;
        String errorMessage = "Xatolik: ${response.statusCode}";
        if (errorData is Map && errorData.isNotEmpty) {
          errorMessage = errorData.toString();
        }
        return Result.error(Exception(errorMessage));
      }
    } catch (e) {
      return Result.error(Exception('Xatolik'));
    }
  }

  Future<FormData> _createFormData({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    final Map<String, dynamic> map = {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
    };

    if (imageFile != null) {
      map['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}
