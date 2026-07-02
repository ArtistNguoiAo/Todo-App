import 'package:bloc/bloc.dart';
import 'package:todo_app/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../model/category.dart';
part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  CreateCategoryCubit() : super(CreateCategoryState(
      name: '',
      selectedColor: ColorUtils.red,
      isSaving: false,
  )
  );

  void selectColor(Color color){
    emit(state.copyWith(selectedColor: color,),);
  }

  void changeName(String name){
    emit(state.copyWith(name: name));
  }

  Future<void> saveOrUpdateCategory() async{
    emit(state.copyWith(isSaving: true));

    if(state.editingCategory == null){
      final newCategory = Category(
        id: 0,
        name: state.name.trim(),
        color: state.selectedColor.value.toRadixString(16),
        createdAt: DateTime.now().toIso8601String(),
      );
      await AppDatabase.instance.insertCategory(newCategory);
    }
    else{
      final category = Category(
        id: state.editingCategory!.id,
        name: state.name.trim(),
        color: state.selectedColor.value.toRadixString(16),
        createdAt: state.editingCategory!.createdAt,
      );
      await AppDatabase.instance.updateCategory(category);
    }
    emit(state.copyWith(isSaving: false));
  }

  void initEdit(Category category){
    emit(state.copyWith(
        name: category.name,
        selectedColor: Color(int.parse(category.color, radix: 16)),
        editingCategory: category,
      )
    );
  }
}
