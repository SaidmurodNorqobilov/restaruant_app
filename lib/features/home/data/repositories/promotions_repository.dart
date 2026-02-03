import 'dart:convert';
import 'package:restaurantapp/core/network/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/result.dart';
import '../models/promotions_model.dart';

class PromotionsRepository {
  final ApiClient _client;

  PromotionsRepository({required ApiClient client}) : _client = client;

  Future<Result<List<PromotionsModel>>> postPromotions({
    Map<String, dynamic>? data,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await _client.post<List<dynamic>>(
      '/products/get_all_promotion/',
      data: data,
    );

    return result.fold(
      (error) {
        final cachedData = prefs.getString('cached_promotions');
        if (cachedData != null) {
          try {
            final List<dynamic> decodedData = jsonDecode(cachedData);
            final promotions = decodedData
                .map((x) => PromotionsModel.fromJson(x as Map<String, dynamic>))
                .toList();
            return Result.ok(promotions);
          } catch (e) {
            return Result.error(Exception("Cache parse error: $e"));
          }
        }
        return Result.error(error);
      },
      (responseData) async {
        try {
          await prefs.setString('cached_promotions', jsonEncode(responseData));
          final promotions = responseData
              .map((x) => PromotionsModel.fromJson(x as Map<String, dynamic>))
              .toList();
          return Result.ok(promotions);
        } catch (e) {
          return Result.error(Exception("Data mapping error: $e"));
        }
      },
    );
  }
}
