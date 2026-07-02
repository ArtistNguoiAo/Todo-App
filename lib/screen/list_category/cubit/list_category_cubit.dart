import 'dart:ui';

import 'package:bloc/bloc.dart';

import '../../../database/database.dart';
import '../../../model/category.dart';

part 'list_category_state.dart';

class ListCategoryCubit extends Cubit<ListCategoryState> {
  ListCategoryCubit() : super(ListCategoryState(
      isLoading: false,
      categories: [],
  ));

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

  Color parseColor(String hexColor) {
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> deleteCategory(int id) async {
    await AppDatabase.instance.deleteCategory(id);

    await loadCategories();
  }
}
