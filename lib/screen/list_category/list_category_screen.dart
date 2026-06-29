import 'package:flutter/material.dart';
import 'package:todo_app/utils/string_utils.dart';
import 'package:todo_app/utils/custom_text.dart';

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
      body: SingleChildScrollView(

      )
    );
  }
}
