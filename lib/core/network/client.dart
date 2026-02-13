import 'package:dio/dio.dart';
import 'package:restaurantapp/features/auth/data/datasources/auth_storage.dart';
import 'package:restaurantapp/core/error/result.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;

    if (path.contains('/auth')) {
      return handler.next(options);
    }

    final token = await AuthStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/refresh-token')) {
      if (_isRefreshing) {
        return handler.next(err);
      }

      _isRefreshing = true;

      try {
        final refreshToken = await AuthStorage.getRefreshToken();

        if (refreshToken != null && refreshToken.isNotEmpty) {
          final refreshDio = Dio(
            BaseOptions(baseUrl: "https://api.cashout.uz"),
          );

          final response = await refreshDio.post(
            '/auth/refresh-token',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final newAccessToken = response.data['access_token'] as String?;
            final newRefreshToken = response.data['refresh_token'] as String?;

            if (newAccessToken != null) {
              await AuthStorage.saveToken(newAccessToken);
              if (newRefreshToken != null) {
                await AuthStorage.saveRefreshToken(newRefreshToken);
              }

              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await _dio.fetch(options);
              _isRefreshing = false;
              return handler.resolve(retryResponse);
            }
          }
        }

        await AuthStorage.clearAll();
        _isRefreshing = false;
        return handler.next(err);
      } catch (e) {
        await AuthStorage.clearAll();
        _isRefreshing = false;
        return handler.next(err);
      }
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
          baseUrl: "http://45.138.158.158:3003",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor(_dio));
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
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> post<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return Result.ok(response.data as T);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> put<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> patch<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return Result.ok(response.data as T);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['message'] ?? e.message));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> delete<T>(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return Result.ok(response.data as T);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
