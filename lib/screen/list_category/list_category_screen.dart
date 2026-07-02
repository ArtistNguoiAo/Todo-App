import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/create_category/cubit/create_category_cubit.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/utils/custom_text.dart';
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
        title: Text(StringUtils.catalog, style: AppTextStyles.heading1,),
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
                  final categoryColor = context.read<ListCategoryCubit>().parseColor(category.color);

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: categoryColor.withOpacity(0.2)
                        ),
                        child: Icon(Icons.local_offer_outlined, color: categoryColor, size: 28,),
                      ),
                      title: Text(category.name),
                      subtitle: Text("0 ghi chú"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Icon(Icons.edit_outlined, color: Colors.grey[700]),
                            onTap: () async{
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => CreateCategoryCubit(),
                                    child: CreateCategoryScreen(
                                      category: category,
                                    ),
                                  ),
                                ),
                              );
                              if (result == true) {
                                context.read<ListCategoryCubit>().loadCategories();
                              }
                            },
                          ),
                          SizedBox(width: 16,),
                          InkWell(
                            child: Icon(Icons.delete_outline, color: Colors.grey[700]),
                            onTap: () {
                              context.read<ListCategoryCubit>().deleteCategory(category.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 120, right: 20),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => CreateCategoryCubit(),
                    child: const CreateCategoryScreen(),
                  ),
                ),
              );

              if (result == true) {
                context.read<ListCategoryCubit>().loadCategories();
              }
            },
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            child: const Icon(Icons.add, color: Colors.white, size: 60),
          ),
        ),
    );
  }
}
