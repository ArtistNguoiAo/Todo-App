import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_text.dart';

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
        width: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          child: Center(child: Text(text, style: AppTextStyles.buttonText,)),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget{
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  CustomTextField({super.key, required this.hintText, this.onChanged, this.controller});

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

class DeleteInkWell extends StatelessWidget{
  final Color bgColor;
  final String text;
  final VoidCallback onTap;

  const DeleteInkWell ({super.key, required this.bgColor, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: InkWell(
        onTap: onTap,
        // splashColor: Colors.grey[500],
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18),),
        ),
      ),
    );
  }
}