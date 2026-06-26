import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_text.dart';
import 'package:todo_app/utils/custom_widgets.dart';
import 'package:todo_app/utils/string_utils.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD0),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Color(0xFFFFFDD0),
        automaticallyImplyLeading: false,
        leading: _backButton(),
        title: Text(StringUtils.new_note, style: AppTextStyles.heading2,),
        actions: [
          SaveButton(text: StringUtils.create,),
        ],
      ),
      body:Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

        ),
      )
    );
  }
  
  Widget _backButton(){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 6.0, bottom: 6.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: InkWell(
          child: Icon(Icons.arrow_back_rounded, color: Colors.black,),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
