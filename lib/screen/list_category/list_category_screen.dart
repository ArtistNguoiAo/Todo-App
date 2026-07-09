import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/create_category/cubit/create_category_cubit.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/widget/custom_text.dart';
import 'package:todo_app/widget/dialog.dart';
import '../../utils/color_utils.dart';
import '../create_category/create_category_screen.dart';


class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF6F5F0),
        title: Text(StringUtils.catalog1, style: AppTextStyles.heading1,),
      ),
      body: BlocBuilder<ListCategoryCubit, ListCategoryState>(
          builder: (context, state) {
            if(state.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            return ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index){
                  final category = state.categories[index];
                  final categoryColor = parseColor(category.color);

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => CreateCategoryCubit(),
                              child: CreateCategoryScreen(
                                category: category,
                              ),
                            ),
                          ),
                        ).then((result) {
                          if (result == true) {
                            context.read<ListCategoryCubit>().loadCategories();
                          }
                        });
                      },
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: categoryColor.withOpacity(0.1)
                          ),
                          child: Icon(Icons.local_offer_outlined, color: categoryColor, size: 28,),
                        ),
                        title: Text(category.name, style: AppTextStyles.bodyLarge(),),
                        subtitle: Text("0 ghi chú"),
                        trailing: InkWell(
                          child: Icon(Icons.delete_outline, color: Colors.grey[700]),
                          onTap: () {
                            AppDialog.showDeleteDialog(
                                context: context,
                                onDelete: () async{
                                  context.read<ListCategoryCubit>().deleteCategory(category.id);
                                }
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
