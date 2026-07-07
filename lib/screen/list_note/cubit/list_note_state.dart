part of 'list_note_cubit.dart';

class ListNoteState{
  final bool isLoading;
  final List<Note> notes;
  final List<NoteCategory> categories;
  final NoteCategory? selectedCategory;

  ListNoteState({
    this.isLoading = false,
    this.notes = const [],
    this.categories = const [],
    this.selectedCategory,
  });

  ListNoteState copyWith({
    bool? isLoading,
    List<Note>? notes,
    List<NoteCategory>? categories,
    NoteCategory? selectedCategory
  }) {
    return ListNoteState(
        isLoading: isLoading ?? this.isLoading,
        notes: notes ?? this.notes,
        categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

}
