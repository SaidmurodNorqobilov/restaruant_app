import 'package:restaurantapp/core/utils/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/client.dart';
import '../../../core/utils/result.dart';

class AuthRepository {
  final ApiClient _client;
  bool _isNewUserTemp = false;

  AuthRepository({required ApiClient client}) : _client = client;

  Future<Result<String>> sendPhone(String phone) async {
    _isNewUserTemp = true;
    final response = await _client.post<Map<String, dynamic>>(
      '/accounts/register/',
      data: {'phone': phone},
    );

    return response.fold(
          (error) {
        if (error.toString().contains("allaqachon mavjud")) {
          return _sendPhoneForLogin(phone);
        }
        return Result.error(error);
      },
          (data) {
        final sessionId = data['session_id'] as String?;
        if (sessionId != null) {
          return Result.ok(sessionId);
        } else {
          return Result.error(Exception("Javobda session_id topilmadi"));
        }
      },
    );
  }

  Future<Result<String>> _sendPhoneForLogin(String phone) async {
    _isNewUserTemp = false;
    final response = await _client.post<Map<String, dynamic>>(
      '/accounts/login/',
      data: {'phone': phone},
    );

    return response.fold(
          (error) => Result.error(error),
          (data) {
        final sessionId = data['session_id'] as String?;
        if (sessionId != null) {
          return Result.ok(sessionId);
        } else {
          return Result.error(Exception("Login javobida session_id topilmadi"));
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> verifyCode(
      String sessionId,
      String code,
      ) async {
    final response = await _client.post(
      '/accounts/verification/',
      data: {
        'session_id': sessionId,
        'code': code,
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

          return Result.ok({
            'access_token': accessToken,
            'refresh_token': refreshToken,
            'is_new_user': _isNewUserTemp,
          });
        } else {
          return Result.error(Exception("Token topilmadi"));
        }
      },
    );
  }

  Future<void> logout() async {
    await AuthStorage.deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  }
}