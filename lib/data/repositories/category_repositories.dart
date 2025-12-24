import '../../core/client.dart';
import '../../core/utils/result.dart';
import '../models/categories_model.dart';

class ProductRepository {
  final ApiClient _client;

  ProductRepository({required ApiClient client}) : _client = client;

  Future<Result<List<CategoriesModel>>> getProducts({
    int? categoryId,
    String? title,
    double? minPrice,
    double? maxPrice,
    int? orderBy,
    int? sizeId,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (categoryId != null && categoryId != 0) {
      queryParams['CategoryId'] = categoryId.toString();
    }

    if (title != null && title.isNotEmpty) {
      queryParams['Title'] = title;
    }

    if (minPrice != null) {
      queryParams['MinPrice'] = minPrice.toInt().toString();
    }

    if (maxPrice != null) {
      queryParams['MaxPrice'] = maxPrice.toInt().toString();
    }

     if (orderBy != null) {
      queryParams['OrderBy'] = orderBy.toString();
    }

    if (sizeId != null) {
      queryParams['SizeId'] = sizeId.toString();
    }

    final result = await _client.get<List<dynamic>>(
      '/products/list',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );

    return result.fold(
          (error) => Result.error(error),
          (data) {
        try {
          final products = data
              .map((x) => CategoriesModel.fromJson(x as Map<String, dynamic>))
              .toList();
          return Result.ok(products);
        } catch (e) {
          return Result.error(
            Exception("Mahsulotlarni parse qilishda xato: $e"),
          );
        }
      },
    );
  }
}
