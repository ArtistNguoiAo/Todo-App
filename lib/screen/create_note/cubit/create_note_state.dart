part of 'create_note_cubit.dart';

class CreateNoteState{
  final int selectedPriority;
  final bool isSaving;
  final Category? selectedCategory;

  CreateNoteState({
    this.selectedPriority = 2,
    this.isSaving = false,
    this.selectedCategory,
});

  CreateNoteState copyWith({
    int? selectedPriority,
    bool? isSaving,
    Category? selectedCategory,
}){
    return CreateNoteState(
      selectedPriority: selectedPriority ?? this.selectedPriority,
      isSaving: isSaving ?? this.isSaving,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
