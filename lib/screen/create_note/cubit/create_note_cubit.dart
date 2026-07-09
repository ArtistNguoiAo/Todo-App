
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:todo_app/enum/note_priority_enum.dart';

import '../../../database/database.dart';
import '../../../model/category.dart';
import '../../../model/note.dart';
part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit() : super(CreateNoteState());

  void selectPriority(NotePriorityEnum priority){
    emit(state.copyWith(selectedPriority: priority),);
  }


  void changeCategory(NoteCategory? category){
    emit(state.copyWith(
      selectedCategory: () => category,
    ));
  }

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateContent(String content) {
    emit(state.copyWith(content: content));
  }


  Future<void> saveOrUpdateNote() async {
    emit(state.copyWith(isSaving: true));

    if (state.editingNote == null) {
      final newNote = Note(
        id: 0,
        categoryId: state.selectedCategory?.id,
        title: state.title.trim(),
        content: state.content.trim(),
        isDone: false,
        priority: state.selectedPriority,
        scheduledAt: state.selectedDate!.millisecondsSinceEpoch,
      );
      await AppDatabase.instance.insertNote(newNote);
    } else {
      final note = Note(
        id: state.editingNote!.id,
        categoryId: state.selectedCategory?.id,
        title: state.title.trim(),
        content: state.content.trim(),
        isDone: state.editingNote!.isDone,
        priority: state.selectedPriority,
        scheduledAt: state.selectedDate!.millisecondsSinceEpoch,
      );
      await AppDatabase.instance.updateNote(note);
    }
    emit(state.copyWith(isSaving: false));
  }

  void changeDate(DateTime date){
    emit(state.copyWith(selectedDate: date));
  }

  void getListNoteCategory() async {
    final listCategory = await AppDatabase.instance.getAllCategories();
    emit(state.copyWith(listCategory: listCategory));
  }

  Future<void> initEdit(Note note) async{
    final listCategory = await AppDatabase.instance.getAllCategories();
    final selectedCategory = listCategory.firstWhereOrNull((category) => category.id == note.categoryId);

    emit(state.copyWith(
      listCategory: listCategory,
      selectedPriority: note.priority,
      selectedCategory: () => selectedCategory,
      title: note.title,
      content: note.content,
      editingNote: note,
      selectedDate: DateTime.fromMillisecondsSinceEpoch(note.scheduledAt),
    )
    );
  }
}