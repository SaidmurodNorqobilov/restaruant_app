import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/category_repositories.dart';
import 'categories_state.dart';

part 'categories_event.dart';

class CategoriesBLoc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _categoryRepository;
  List<CategoryModel> _allCategories = [];

  int _currentPage = 1;

  CategoriesBLoc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoriesState.initial()) {
    on<CategoriesLoading>(_onCategoriesLoading);
    on<CategoriesSearch>(_onCategoriesSearch);
    on<CategoryGetId>(_onCategoryGetById);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onCategoriesLoading(
      CategoriesLoading event,
      Emitter<CategoriesState> emit,
      ) async {
    if (state.categories.isEmpty) {
      emit(state.copyWith(status: Status.loading));
    }

    final result = await _categoryRepository.getCategories();

    result.fold(
          (error) {
        if (state.categories.isEmpty) {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: error.toString(),
          ));
        }
      },
          (data) {
        _allCategories = data;
        emit(state.copyWith(status: Status.success, categories: data));
      },
    );
  }

  void _onCategoriesSearch(
      CategoriesSearch event,
      Emitter<CategoriesState> emit,
      ) {
    if (event.query.isEmpty) {
      emit(state.copyWith(categories: _allCategories));
    } else {
      final filtered = _allCategories
          .where((cat) => cat.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(categories: filtered));
    }
  }

  Future<void> _onCategoryGetById(
      CategoryGetId event,
      Emitter<CategoriesState> emit,
      ) async {
    _currentPage = 1;

    emit(state.copyWith(
      status: Status.loading,
      products: [],
      hasReachedMax: false,
      isLoadingMore: false,
    ));

    final result = await _categoryRepository.getProducts(
      categoryId: event.id,
      page: _currentPage,
      limit: 15,
    );

    result.fold(
          (error) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ));
      },
          (data) {
        emit(state.copyWith(
          status: Status.success,
          products: data.productItem,
          hasReachedMax: _currentPage >= data.totalPage,
        ));
      },
    );
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event,
      Emitter<CategoriesState> emit,
      ) async {
    if (state.isLoadingMore || state.hasReachedMax) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    _currentPage++;
    final result = await _categoryRepository.getProducts(
      categoryId: event.categoryId,
      page: _currentPage,
      limit: 12,
    );

    result.fold(
          (error) {
        _currentPage--;
        emit(state.copyWith(isLoadingMore: false));
      },
          (data) {
        final updatedProducts = List<ProductModelItem>.from(state.products)
          ..addAll(data.productItem);

        emit(state.copyWith(
          status: Status.success,
          products: updatedProducts,
          hasReachedMax: _currentPage >= data.totalPage,
          isLoadingMore: false,
        ));
      },
    );
  }
}