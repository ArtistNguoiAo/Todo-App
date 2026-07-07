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

  Future<void> deleteCategory(int id) async {
    await AppDatabase.instance.deleteNote(id);

    await loadNotes();
  }

  void changeCategory(NoteCategory? category){
    emit(state.copyWith(
      selectedCategory: category,
    ));
  }

  Future<void> loadCategories() async{
    emit(state.copyWith(
        isLoading: true
    ));

    final data = await AppDatabase.instance.getAllCategories();

    emit(state.copyWith(
      isLoading: false,
      categories: data,
    ));
  }
}
