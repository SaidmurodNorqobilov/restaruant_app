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
    final token = prefs.getString("access_token");
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
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

        if (response.data is String) {
          errorMessage = response.data as String;
        } else if (response.data is Map<String, dynamic>) {
          if (response.data!.containsKey('detail')) {
            errorMessage = response.data!['detail'];
          } else if (response.data!.containsKey('error')) {
            errorMessage = response.data!['error'];
          } else {
            errorMessage =
                response.data!['message'] ?? response.data.toString();
          }
        }

        return Result.error(
          Exception(errorMessage),
        );
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

  Future<Result<T>> patchWithFormData<T>(String path, {required FormData data}) async {
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
