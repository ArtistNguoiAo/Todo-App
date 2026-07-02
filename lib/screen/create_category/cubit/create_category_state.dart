part of 'create_category_cubit.dart';

class CreateCategoryState {
  final String name;
  final Color selectedColor;
  final bool isSaving;
  final Category? editingCategory;

  CreateCategoryState({
    required this.name,
    required this.selectedColor,
    required this.isSaving,
    this.editingCategory,
  });

  CreateCategoryState copyWith({
    String? name,
    Color? selectedColor,
    bool? isSaving,
    Category? editingCategory,
}) {
    return CreateCategoryState(
        name: name ?? this.name,
        selectedColor: selectedColor ?? this.selectedColor,
        isSaving: isSaving ?? this.isSaving,
        editingCategory: editingCategory ?? this.editingCategory,
    );
  }
}

