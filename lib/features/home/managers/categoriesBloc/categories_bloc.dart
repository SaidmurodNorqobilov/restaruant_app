import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurantapp/core/utils/status.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/repositories/category_repositories.dart';
import 'categories_state.dart';

part 'categories_event.dart';

class CategoriesBLoc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoryRepository _categoryRepository;
  List<CategoryModel> _allCategories = [];

  CategoriesBLoc({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository,
      super(CategoriesState.initial()) {
    on<CategoriesLoading>(_onCategoriesLoading);
    on<CategoriesSearch>(_onCategoriesSearch);
    on<CategoryGetId>(_onCategoryGetById);
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
          emit(
            state.copyWith(
              status: Status.error,
              errorMessage: error.toString(),
            ),
          );
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
          .where(
            (cat) => cat.name.toLowerCase().contains(
              event.query.toLowerCase(),
            ),
          )
          .toList();
      emit(
        state.copyWith(
          categories: filtered,
        ),
      );
    }
  }

  Future<void> _onCategoryGetById(
    CategoryGetId event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(
      state.copyWith(status: Status.loading),
    );

    final result = await _categoryRepository.getProductsByCategoryId(
      event.id,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: Status.error,
          errorMessage: error.toString(),
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: Status.success,
          products: data,
        ),
      ),
    );
  }
}
