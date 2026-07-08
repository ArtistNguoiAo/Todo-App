import 'package:bloc/bloc.dart';
import 'package:todo_app/model/category.dart';

import '../../../database/database.dart';
import '../../../model/note.dart';

part 'list_note_state.dart';

class ListNoteCubit extends Cubit<ListNoteState> {
  ListNoteCubit() : super(ListNoteState());

  DateTime _getOnlyDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  Map<DateTime, List<Note>> _groupNotesByDate(List<Note> notes) {

    final Map<DateTime, List<Note>> grouped = {};

    for (final note in notes) {

      final date = _getOnlyDate(note.createdAt);

      grouped.putIfAbsent(date, () => []);

      grouped[date]!.add(note);
    }

    return grouped;
  }

  Future<void> loadNotes() async{
    emit(state.copyWith(
        isLoading: true
    ));

    final data = await AppDatabase.instance.getAllNotes();
    final groupedNotes = _groupNotesByDate(data);

    emit(state.copyWith(
      isLoading: false,
      notes: data,
      groupedNotes: groupedNotes,
    ));
  }

  Future<void> deleteNote(int id) async {
    await AppDatabase.instance.deleteNote(id);

    await loadNotes();
  }

  void changeCategory(NoteCategory? category){
    emit(state.copyWith(
      selectedCategory: category,
    ));
  }

  Future<void> toggleDone(int id, bool value) async{
    await AppDatabase.instance.updateNoteDone(id, value);
    await loadNotes();
  }
}
