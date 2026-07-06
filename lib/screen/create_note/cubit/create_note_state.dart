part of 'create_note_cubit.dart';

class CreateNoteState{
  final NotePriorityEnum selectedPriority;
  final bool isSaving;
  final NoteCategory? selectedCategory;
  final String title;
  final String content;
  final DateTime? selectedDate;
  final List<NoteCategory> listCategory;

  CreateNoteState({
    this.selectedPriority = NotePriorityEnum.medium,
    this.isSaving = false,
    this.selectedCategory,
    this.title = '',
    this.content = '',
    this.selectedDate,
    this.listCategory = const [],
});

  CreateNoteState copyWith({
    NotePriorityEnum? selectedPriority,
    bool? isSaving,
    NoteCategory? selectedCategory,
    String? title,
    String? content,
    DateTime? selectedDate,
    List<NoteCategory>? listCategory
  }) {
    return CreateNoteState(
      selectedPriority: selectedPriority ?? this.selectedPriority,
      isSaving: isSaving ?? this.isSaving,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      title: title ?? this.title,
      content: content ?? this.content,
      selectedDate: selectedDate ?? this.selectedDate,
      listCategory: listCategory ?? this.listCategory
    );
  }
}
