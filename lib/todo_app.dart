import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screen/auth/login_screen.dart';
import 'package:todo_app/screen/home/home_screen.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/screen/list_note/cubit/list_note_cubit.dart';

import 'database/firebase_auth.dart';
import 'database/fcm_service.dart';

class TodoApp extends StatefulWidget{
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}
class _TodoAppState extends State<TodoApp> {

  @override
  void initState(){
    super.initState();
    FCMService.setupFCM();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ListNoteCubit()..loadNotes(),
                ),
                BlocProvider(
                  create: (_) => ListCategoryCubit()..loadCategories(),
                ),
              ],
              child: const HomeScreen(),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

