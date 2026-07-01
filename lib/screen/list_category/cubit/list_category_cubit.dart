import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/category.dart';

part 'list_category_state.dart';

class ListCategoryCubit extends Cubit<ListCategoryState> {
  ListCategoryCubit() : super(ListCategoryState(
      isLoading: true,
      categories: [],
  ));


}
