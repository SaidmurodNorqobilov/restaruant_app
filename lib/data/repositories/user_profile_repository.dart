import 'package:dio/dio.dart';
import 'package:restaurantapp/core/client.dart';
import 'package:restaurantapp/core/utils/result.dart';
import '../models/user_profile_model.dart';

class UserProfileRepository {
  final ApiClient _client;

  UserProfileRepository({required ApiClient client}) : _client = client;

  Future<Result<UserProfileModel>> getUserProfile() async {
    final result = await _client.get<Map<String, dynamic>>('/accounts/get_my_profile/');

    return result.fold(
          (error) => Result.error(error),
          (data) {
        try {
          return Result.ok(UserProfileModel.fromJson(data));
        } catch (e) {
          return Result.error(Exception('Parsing error: $e'));
        }
      },
    );
  }

  Future<Result<UserProfileModel>> patchUserProfile(UserProfilePostModel profile) async {
    final Map<String, dynamic> map = profile.toJson();

    if (profile.imageFile != null) {
      map['image'] = await MultipartFile.fromFile(
        profile.imageFile!.path,
        filename: profile.imageFile!.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(map);

    print('Sending data to server:');
    print('firstName: ${profile.firstName}');
    print('lastName: ${profile.lastName}');
    print('region: ${profile.address}');
    print('imageFile: ${profile.imageFile?.path}');

    final result = await _client.patchWithFormData<Map<String, dynamic>>(
      '/accounts/update_my_profile/',
      data: formData,
    );

    return result.fold(
          (error) => Result.error(error),
          (data) {
        try {
          print('Received from server: $data');
          return Result.ok(UserProfileModel.fromJson(data));
        } catch (e) {
          return Result.error(Exception('Parsing error: $e'));
        }
      },
    );
  }
}