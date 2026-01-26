import 'package:restaurantapp/core/client.dart';
import '../../core/utils/result.dart';
import '../models/cart_model.dart';

class CartRepository {
  final ApiClient _client;

  CartRepository({required ApiClient client}) : _client = client;

  Future<Result<List<CartModel>>> getCart() async {
    final response = await _client.get<List<dynamic>>(
      '/products/get_all_my_basket_items/',
    );

    return response.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final items = data.map((json) => CartModel.fromJson(json)).toList();
          return Result.ok(items);
        } catch (e) {
          return Result.error(
            Exception(
              e.toString(),
            ),
          );
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> updateCartItem({
    required int itemId,
    required int quantity,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/products/update_order_item/$itemId/',
      data: {
        "item_id": itemId,
        "quantity": quantity,
      },
    );

    return response.fold(
      (error) => Result.error(error),
      (data) => Result.ok(data),
    );
  }

  Future<Result<void>> deleteCartItem(int itemId) async {
    final response = await _client.delete(
      '/products/delete_basket/$itemId/',
    );

    return response.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }
}
