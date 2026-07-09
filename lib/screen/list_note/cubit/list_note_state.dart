part of 'list_note_cubit.dart';

class ListNoteState{
  final bool isLoading;
  final List<Note> notes;
  final NoteCategory? selectedCategory;

  ListNoteState({
    this.isLoading = false,
    this.notes = const [],
    this.selectedCategory,
  });

  Map<DateTime, List<Note>> get filteredGroupedNotes {
    //Lọc danh sách theo danh mục đang chọn
    final filteredNotes = selectedCategory == null
        ? notes
        : notes.where((note) => note.categoryId == selectedCategory!.id).toList();

    //Nhóm danh sách đã lọc theo ngày
    final Map<DateTime, List<Note>> grouped = {};
    for (final note in filteredNotes) {
      final date = DateTime.fromMillisecondsSinceEpoch(note.scheduledAt);
      final onlyDate = DateTime(date.year, date.month, date.day);

      grouped.putIfAbsent(onlyDate, () => []);
      grouped[onlyDate]!.add(note);
    }
    return grouped;
  }

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
    );
  }

}
