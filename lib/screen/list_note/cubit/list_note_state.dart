part of 'list_note_cubit.dart';

class ListNoteState{
  final bool isLoading;
  final List<Note> notes;
  final NoteCategory? selectedCategory;
  final Map<DateTime, List<Note>> groupedNotes;

  ListNoteState({
    this.isLoading = false,
    this.notes = const [],
    this.selectedCategory,
    this.groupedNotes = const {},
  });

  ListNoteState copyWith({
    bool? isLoading,
    List<Note>? notes,
    NoteCategory? selectedCategory,
    Map<DateTime, List<Note>>? groupedNotes,
  }) {
    return ListNoteState(
        isLoading: isLoading ?? this.isLoading,
        notes: notes ?? this.notes,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        groupedNotes: groupedNotes ?? this.groupedNotes,
    );
  }

}
