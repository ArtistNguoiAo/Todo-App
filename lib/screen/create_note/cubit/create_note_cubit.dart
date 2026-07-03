
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/model/note.dart';
part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit() : super(CreateNoteState());

  void selectPriority(int priority){
    emit(state.copyWith(selectedPriority: priority),);
  }

  // Future<void> saveNote() async{
  //   emit(state.copyWith(isSaving: true));
  //
  //   final newNote = Note(
  //       id: 0,
  //       categoryId: categoryId,
  //       title: title,
  //       content: content,
  //       isDone: isDone,
  //       priority: priority,
  //       createdAt: DateTime.now().toIso8601String(),
  //   );

    // await AppDatabase.instance.insertCategory(newCategory);

}
