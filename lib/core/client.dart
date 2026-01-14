import 'package:dio/dio.dart';
import 'package:restaurantapp/core/network/auth_storage.dart';
import 'package:restaurantapp/core/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;

    if (path.contains('/accounts/register/') ||
        path.contains('/accounts/login/') ||
        path.contains('/accounts/verification/')) {
      // shu qatorni qushdm
      return handler.next(options);
    }

    final token = await AuthStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AuthStorage.deleteToken();
    }
    handler.next(err);
  }
}

class ApiClient {
  final Dio _dio;

  Dio get dio => _dio;

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: "https://atsrestaurant.pythonanywhere.com",
          validateStatus: (status) => true,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      if (response.statusCode != 200) {
        return Result.error(Exception("${response.data}"));
      }
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> post<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.ok(response.data as T);
      } else {
        String errorMessage = "Xatolik: ${response.statusCode}";

        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          if (responseData.containsKey('messages') &&
              responseData['messages'] is List) {
            final messages = responseData['messages'] as List;
            if (messages.isNotEmpty &&
                messages[0] is Map &&
                messages[0].containsKey('message')) {
              errorMessage = messages[0]['message'].toString();
            }
          } else if (responseData.containsKey('detail')) {
            errorMessage = responseData['detail'].toString();
          } else if (responseData.containsKey('error')) {
            errorMessage = responseData['error'].toString();
          } else if (responseData.containsKey('message')) {
            errorMessage = responseData['message'].toString();
          } else {
            errorMessage = responseData.toString();
          }
        } else if (response.data is String) {
          errorMessage = response.data as String;
        }

        return Result.error(Exception(errorMessage));
      }
    } on DioException catch (e) {
      return Result.error(Exception(e.message ?? e.toString()));
    } catch (e) {
      return Result.error(Exception("Kutilmagan xato: ${e.toString()}"));
    }
  }

  Future<Result<T>> put<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.ok(response.data as T);
      } else {
        return Result.error(
          Exception("Xatolik: ${response.statusCode} - ${response.data}"),
        );
      }
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> patch<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Result.error(
          Exception("Xatolik: ${response.statusCode} - ${response.data}"),
        );
      }
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> patchWithFormData<T>(
    String path, {
    required FormData data,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Result.error(
          Exception("Xatolik: ${response.statusCode} - ${response.data}"),
        );
      }
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> delete<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.statusCode == 204 || response.data == null) {
          return Result.ok(null as T);
        }
        return Result.ok(response.data as T);
      } else {
        return Result.error(
          Exception("Xatolik: ${response.statusCode} - ${response.data}"),
        );
      }
    } on DioException catch (e) {
      return Result.error(Exception(e.message ?? e.toString()));
    } catch (e) {
      return Result.error(Exception("Kutilmagan xato: ${e.toString()}"));
    }
  }
}
