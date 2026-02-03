import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/client.dart';
import '../../../../core/error/result.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _client;

  CategoryRepository({required ApiClient client}) : _client = client;

  Future<Result<List<CategoryModel>>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final result = await _client.get<List<dynamic>>(
      '/categories',
    );
    return result.fold(
          (error) {
        final cachedData = prefs.getString('cached_categories');
        if (cachedData != null) {
          try {
            final List<dynamic> decodedData = jsonDecode(cachedData);
            final categories = decodedData
                .map((x) => CategoryModel.fromJson(x as Map<String, dynamic>))
                .toList();
            return Result.ok(categories);
          } catch (e) {
            return Result.error(Exception("Cache parse error: $e"));
          }
        }
        return Result.error(error);
      },
          (data) {
        try {
          prefs.setString('cached_categories', jsonEncode(data));
          final categories = data.map((x) {
            final Map<String, dynamic> map = x as Map<String, dynamic>;
            if (map['image'] == null || map['image'].toString().isEmpty) {
              map['image'] = "";
            }
            return CategoryModel.fromJson(map);
          }).toList();
          return Result.ok(categories);
        } catch (e) {
          return Result.error(Exception("Category parse error: $e"));
        }
      },
    );
  }

  Future<Result<ProductModel>> getProducts({
    required String categoryId,
    int page = 1,
    int limit = 10,
    double? priceMin,
    double? priceMax,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_products_${categoryId}_page_$page';

    final Map<String, dynamic> params = {
      'page': page,
      'limit': limit,
      'category_id': categoryId,
    };

    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;

    final result = await _client.get<Map<String, dynamic>>(
      '/products',
      queryParams: params,
    );

    return result.fold(
          (error) {
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final decodedData = jsonDecode(cachedData);
            return Result.ok(ProductModel.fromJson(decodedData));
          } catch (e) {
            return Result.error(Exception("Cache parse error: $e"));
          }
        }
        return Result.error(error);
      },
          (data) {
        try {
          prefs.setString(cacheKey, jsonEncode(data));
          final productResponse = ProductModel.fromJson(data);
          return Result.ok(productResponse);
        } catch (e) {
          return Result.error(Exception("Data parse error: $e"));
        }
      },
    );
  }
}