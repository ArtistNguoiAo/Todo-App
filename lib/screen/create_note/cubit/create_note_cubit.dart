import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
    log("TrungLQ: ${category?.id}");
    emit(state.copyWith(
      selectedCategory: category,
    ));
  }

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateContent(String content) {
    emit(state.copyWith(content: content));
  }

  Future<void> saveNote() async {
    if(state.title.trim().isEmpty){
      return;
    }

    emit(state.copyWith(isSaving: true));

    final newNote = Note(
      id: 0,
      categoryId: state.selectedCategory?.id,
      title: state.title,
      content: state.content,
      isDone: false,
      priority: state.selectedPriority,
      createdAt: DateTime.now().microsecondsSinceEpoch,
    );

    await AppDatabase.instance.insertNote(newNote);

    emit(state.copyWith(isSaving: false));
  }

  void changeDate(DateTime date){
    emit(state.copyWith(selectedDate: date));
  }

  void getListNoteCategory() async {
    final listCategory = await AppDatabase.instance.getAllCategories();
    emit(state.copyWith(listCategory: listCategory));
  }
}