import 'package:restaurantapp/core/client.dart';
import '../../core/utils/result.dart';
import '../models/category_model.dart';

class ProductRepository {
  final ApiClient _client;

  ProductRepository({required ApiClient client}) : _client = client;

  Future<Result<List<ProductModel>>> getProducts() async {
    final response = await _client.get<List<dynamic>>(
      '/products/get_all_products/',
    );
    return response.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final products = data
              .map((item) => ProductModel.fromJson(item))
              .toList();
          return Result.ok(products);
        } catch (e) {
          return Result.error(Exception("Parsing error: $e"));
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> addOrderItem({
    required int productId,
    required int quantity,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/products/add_or_get_basket/',
      data: {
        "product": productId,
        "quantity": quantity,
      },
    );

    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(data),
    );
  }

  Future<Result<void>> updateLocation(
    String address,
    double lat,
    double lng,
  ) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/accounts/update_profile/',
      data: {
        "address": address,
        "latitude": lat,
        "longitude": lng,
      },
    );
    return response.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }
}
