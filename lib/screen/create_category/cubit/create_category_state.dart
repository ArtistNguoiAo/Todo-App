part of 'create_category_cubit.dart';

class CreateCategoryState{
  final String name;
  final Color selectedColor;
  final bool isSaving;

  CreateCategoryState({
    required this.name,
    required this.selectedColor,
    required this.isSaving,
  });

  CreateCategoryState copyWith({
    String? name,
    Color? selectedColor,
    bool? isSaving,
}) {
    return CreateCategoryState(
        name: name ?? this.name,
        selectedColor: selectedColor ?? this.selectedColor,
        isSaving: isSaving ?? this.isSaving,
    );
  }
}

