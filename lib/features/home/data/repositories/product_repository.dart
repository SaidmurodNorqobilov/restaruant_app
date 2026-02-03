import 'package:restaurantapp/core/network/client.dart';
import '../../../../core/error/result.dart';
import '../models/product_item_model.dart';
import '../models/category_model.dart';

class ProductRepository {
  final ApiClient _client;

  ProductRepository({required ApiClient client}) : _client = client;

  Future<Result<List<ProductModelItem>>> getProducts() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/products/get_all_products/',
    );
    return response.fold(
          (error) => Result.error(error),
          (data) {
        try {
          final List<dynamic> productsJson = data['products'] ?? [];
          final products = productsJson
              .map((item) => ProductModelItem.fromJson(item))
              .toList();
          return Result.ok(products);
        } catch (e) {
          return Result.error(Exception("Parsing error: $e"));
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> addOrderItem({
    required String productId,
    required int quantity,
    List<String>? modifierIds,
  }) async {
    final Map<String, dynamic> body = {
      "product_id": productId,
      "quantity": quantity,
    };

    if (modifierIds != null && modifierIds.isNotEmpty) {
      body["modifiers"] = modifierIds;
    }

    final response = await _client.post<Map<String, dynamic>>(
      '/orders/add-item/',
      data: body,
    );

    return response.fold(
          (error) => Result.error(error),
          (data) => Result.ok(data),
    );
  }

  Future<Result<ProductItemModel>> getProductById(String id) async {
    final response = await _client.get<Map<String, dynamic>>('/products/$id/');

    return response.fold(
          (error) => Result.error(error),
          (data) {
        try {
          return Result.ok(ProductItemModel.fromJson(data));
        } catch (e) {
          return Result.error(Exception("Parsing error: $e"));
        }
      },
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