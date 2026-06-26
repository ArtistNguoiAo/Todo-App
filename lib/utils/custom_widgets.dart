import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_text.dart';

class SaveButton extends StatelessWidget{
  final String text ;

  const SaveButton({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, top: 6.0, bottom: 6.0),
      child: Ink(
        width: 70,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Center(child: Text(text, style: AppTextStyles.buttonText,)),
          onTap: () {},
        ),
      ),
    );
  }
}