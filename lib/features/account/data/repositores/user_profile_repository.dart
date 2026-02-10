import 'package:dio/dio.dart';
import 'package:restaurantapp/core/network/client.dart';
import 'package:restaurantapp/core/error/result.dart';
import '../models/user_profile_model.dart';

class UserProfileRepository {
  final ApiClient _client;

  UserProfileRepository({required ApiClient client}) : _client = client;

  Future<Result<UserProfileModel>> getUserProfile() async {
    final result = await _client.get<Map<String, dynamic>>('/users/find-me');
    return result.fold(
          (error) => Result.error(error),
          (data) => Result.ok(UserProfileModel.fromJson(data)),
    );
  }

  Future<Result<UserProfileModel>> patchUserProfile(
      UserProfilePostModel profile,
      ) async {
    try {
      final Map<String, dynamic> map = {
        'first_name': profile.firstName,
        'last_name': profile.lastName,
      };
      if (profile.imageFile != null) {
        map['image'] = await MultipartFile.fromFile(
          profile.imageFile!.path,
          filename: profile.imageFile!.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(map);
      final result = await _client.patch<Map<String, dynamic>>(
        '/users/update',
        data: formData,
      );
      return result.fold(
            (error) => Result.error(error),
            (data) => Result.ok(UserProfileModel.fromJson(data)),
      );
    } catch (e) {
      return Result.error(Exception('Repository xatosi'));
    }
  }
}