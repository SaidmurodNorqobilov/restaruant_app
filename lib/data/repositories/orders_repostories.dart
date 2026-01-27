import 'package:restaurantapp/core/client.dart';
import '../../core/utils/result.dart';
import '../models/orders_model.dart';

class OrderRepository {
  final ApiClient _client;

  OrderRepository({required ApiClient client}) : _client = client;

  Future<Result<List<OrderModel>>> getOrders() async {
    final result = await _client.get<List<dynamic>>(
      '/products/get_my_orders_list/',
    );

    return result.fold(
          (error) => Result.error(error),
          (data) {
        try {
          final orders = data
              .map((x) => OrderModel.fromJson(x as Map<String, dynamic>))
              .toList();
          return Result.ok(orders);
        } catch (e) {
          return Result.error(
            Exception("Buyurtmalarni o'qishda xatolik"),
          );
        }
      },
    );
  }

  Future<Result<Map<String, dynamic>>> cancelOrder(int orderId) async {
    final result = await _client.get<Map<String, dynamic>>(
      '/products/cancel_order_for_user/$orderId/',
    );
    return result.fold(
          (error) => Result.error(error),
          (data) => Result.ok(data),
    );
  }

  Future<Result<Map<String, dynamic>>> addOrder() async {
    final result = await _client.get<Map<String, dynamic>>(
      '/products/add_order/',
    );
    return result.fold(
          (error) => Result.error(error),
          (data) => Result.ok(data),
    );
  }
}