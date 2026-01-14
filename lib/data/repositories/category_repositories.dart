import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/client.dart';
import '../../core/utils/result.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _client;

  CategoryRepository({required ApiClient client}) : _client = client;

  Future<Result<List<CategoryModel>>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();

    final result = await _client.get<List<dynamic>>(
      '/products/get_all_category/',
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

  Future<Result<List<ProductModel>>> getProductsByCategoryId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_products_$id';

    final result = await _client.get<List<dynamic>>(
      '/products/get_any_cat_and_prod/$id/',
    );

    return result.fold(
      (error) {
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final List<dynamic> decodedData = jsonDecode(cachedData);
            final products = decodedData
                .map((x) => ProductModel.fromJson(x as Map<String, dynamic>))
                .toList();
            return Result.ok(products);
          } catch (e) {
            return Result.error(Exception("Product cache parse error: $e"));
          }
        }
        return Result.error(error);
      },
      (data) {
        try {
          prefs.setString(cacheKey, jsonEncode(data));

          final products = data.map((x) {
            final Map<String, dynamic> map = x as Map<String, dynamic>;
            if (map['image'] == null || map['image'].toString().isEmpty) {
              map['image'] = "";
            }
            return ProductModel.fromJson(map);
          }).toList();

          return Result.ok(products);
        } catch (e) {
          return Result.error(Exception("Product parse error: $e"));
        }
      },
    );
  }
}
