part of 'list_category_cubit.dart';

class ListCategoryState{
  final bool isLoading;
  final List<Category> categories;

  ListCategoryState({
    required this.isLoading,
    required this.categories,
})

  ListCategoryState copyWith({
    bool? isLoading,
    List<Category>? categories,
  }) {
    return ListCategoryState(
        isLoading: isLoading ?? this.isLoading,
        categories: categories ?? this.categories
    );
  }
}
