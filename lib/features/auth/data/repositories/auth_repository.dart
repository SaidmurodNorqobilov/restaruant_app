import 'package:restaurantapp/features/auth/data/datasources/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/client.dart';
import '../../../../core/error/result.dart';

class AuthRepository {
  final ApiClient _client;

  AuthRepository({required ApiClient client}) : _client = client;

  Future<Result<void>> sendPhone(String phone) async {
    final response = await _client.post(
      '/auth',
      data: {'phone': phone},
    );

    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(null),
    );
  }

  Future<Result<Map<String, dynamic>>> verifyCode(
    String phone,
    String code,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {
        'phone': phone,
        'code': int.tryParse(code) ?? 0,
      },
    );
    return response.fold(
      (error) => Result.error(error),
      (data) async {
        final accessToken = data['access_token'] as String?;
        final refreshToken = data['refresh_token'] as String?;
        if (accessToken != null && accessToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("access_token", accessToken);
          await AuthStorage.saveToken(accessToken);
          if (refreshToken != null && refreshToken.isNotEmpty) {
            await AuthStorage.saveRefreshToken(refreshToken);
          }
          return Result.ok(data);
        } else {
          return Result.error(Exception("Token topilmadi"));
        }
      },
    );
  }

  Future<Result<void>> logout() async {
    final response = await _client.post('/auth/logout');

    return response.fold(
      (error) {
        return Result.error(error);
      },
      (data) async {
        try {
          await AuthStorage.clearAll();
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          return Result.ok(null);
        } catch (e) {
          return Result.error(Exception('Storage tozalashda xato: $e'));
        }
      },
    );
  }

  Future<bool> isLoggedIn() async {
    return await AuthStorage.isLoggedIn();
  }
  // Future<Result<Map<String, dynamic>>> _logoutToken() async {
  //
  // }
}
