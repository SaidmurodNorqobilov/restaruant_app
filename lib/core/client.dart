import 'package:dio/dio.dart';
import 'package:restaurantapp/core/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }
}

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.0.63:8888/api/v1",
      validateStatus: (status) => true,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 15),
    ),
  ){
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
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

        if (response.data is String) {
          errorMessage = response.data as String;
        } else if (response.data is Map<String, dynamic>) {
          errorMessage = response.data!['message'] ?? response.data.toString();
        }

        return Result.error(
          Exception(errorMessage),
        );
      }
    } on DioException catch (e) {
      return Result.error(Exception(e.message ?? e.toString()));
    } catch (e) {
      return Result.error(Exception("Kutilmagan konvertatsiya xatosi: ${e.toString()}"));
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

  Future<Result<T>> delete<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(path, data: data);

      if (response.statusCode == 200 || response.statusCode == 204) {
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
