import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/screen/create_category/cubit/create_category_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/utils/custom_text.dart';
import 'package:todo_app/model/category.dart';

import '../create_category/create_category_screen.dart';

class ListCategoryScreen extends StatefulWidget {
  const ListCategoryScreen({super.key});

  @override
  State<ListCategoryScreen> createState() => _ListCategoryScreenState();
}

class _ListCategoryScreenState extends State<ListCategoryScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async{
    setState(() =>_isLoading = true);
    final data = await AppDatabase.instance.getAllCategories();
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFF6F5F0),
        title: Text(StringUtils.catalog, style: AppTextStyles.heading1,),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator(),)
        : ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index){
            final category = _categories[index];
            final categoryColor = _parseColor(category.color);

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
                    InkWell(child: Icon(Icons.edit_outlined, color: Colors.grey[700]),),
                    SizedBox(width: 16,),
                    InkWell(child: Icon(Icons.delete_outline, color: Colors.grey[700]),),
                  ],
                ),
              ),
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
                _loadCategories();
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
