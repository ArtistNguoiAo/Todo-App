import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: 0.5,
  );

  static TextStyle heading2({Color color = Colors.black87}) => TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold, // Semi-bold
    color: color,
  );

  static TextStyle bodyLarge({Color color = Colors.black87}) => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: color,
    height: 1.5, // Line height
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}