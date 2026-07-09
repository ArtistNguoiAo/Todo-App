import 'package:bloc/bloc.dart';
import 'package:todo_app/model/category.dart';

import '../../../database/database.dart';
import '../../../model/note.dart';

part 'list_note_state.dart';

class ListNoteCubit extends Cubit<ListNoteState> {
  ListNoteCubit() : super(ListNoteState());

  Future<void> loadNotes() async{
    emit(state.copyWith(
        isLoading: true
    ));

    final data = await AppDatabase.instance.getAllNotes();

    emit(state.copyWith(
      isLoading: false,
      notes: data,
    ));
  }

  Future<void> deleteNote(int id) async {
    await AppDatabase.instance.deleteNote(id);

    await loadNotes();
  }

  void changeCategory(NoteCategory? category){
    if(category == null){
      emit(ListNoteState(
        notes: state.notes,
        selectedCategory: null,
      ));
    }else{
      emit(state.copyWith(
        selectedCategory: category,
      ));
    }
  }

  Future<void> toggleDone(int id, bool value) async{
    await AppDatabase.instance.updateNoteDone(id, value);
    await loadNotes();
  }
}
