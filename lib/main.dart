import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/home/home_screen.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ListCategoryCubit()..loadCategories(),
        child: const HomeScreen(),
      )
    );
  }
}