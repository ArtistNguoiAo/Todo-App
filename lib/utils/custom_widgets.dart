import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_text.dart';
import 'package:todo_app/screen/create_category/create_category_screen.dart';

class SaveButton extends StatelessWidget{
  final String text ;
  final Function()? onTap;
  final Color color;
  const SaveButton({super.key, required this.text, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, top: 6.0, bottom: 6.0),
      child: Ink(
        width: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          child: Center(child: Text(text, style: AppTextStyles.buttonText,)),
          onTap: onTap,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget{
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  CustomTextField({super.key, required this.hintText, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF858076), fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF3D3C4), width: 2.0),
          borderRadius: BorderRadius.circular(20),// Có thể cho viền dày hơn chút khi focus
        ),
      ),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //Đổi màu con trỏ chuột nhấp nháy thành màu đỏ
      cursorColor: Colors.black,
      );
  }
}

