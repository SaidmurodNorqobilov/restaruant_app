part of 'categories_bloc.dart';

sealed class CategoriesEvent {}

final class CategoriesLoading extends CategoriesEvent {}

class CategoriesSearch extends CategoriesEvent {
  final String query;

  CategoriesSearch(this.query);
}

class CategoryGetId extends CategoriesEvent {
  final int id;

  CategoryGetId(this.id);
}
