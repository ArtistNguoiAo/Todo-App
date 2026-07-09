part of 'list_category_cubit.dart';

class ListCategoryState{
  final bool isLoading;
  final List<NoteCategory> categories;

  ListCategoryState({
    required this.isLoading,
    required this.categories,
});

  ListCategoryState copyWith({
    bool? isLoading,
    List<NoteCategory>? categories,
  }) {
    return ListCategoryState(
        isLoading: isLoading ?? this.isLoading,
        categories: categories ?? this.categories
    );
  }

}
