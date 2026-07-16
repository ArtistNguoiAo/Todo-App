
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:todo_app/database/fcm_service.dart';
import 'package:todo_app/test_api/post_page.dart';
// import 'package:todo_app/todo_app.dart';
// import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // // Khởi tạo Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //
  // // Khởi tạo các cấu hình Kênh và Plugin thông báo ban đầu
  // await FCMService.initNotifications();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PostPage(),
  ),
  );
}

