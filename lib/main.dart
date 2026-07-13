
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/database/firebase_auth.dart'; // 1. Import dịch vụ Auth của bạn
import 'package:todo_app/screen/auth/login_screen.dart'; // 2. Import màn hình Login (tạo ở bước trước)
import 'package:todo_app/screen/home/home_screen.dart';
import 'package:todo_app/screen/list_category/cubit/list_category_cubit.dart';
import 'package:todo_app/screen/list_note/cubit/list_note_cubit.dart';
import 'package:todo_app/utils/string_utils.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Nhận thông báo khi app đóng/nền: ${message.notification?.title}");
}

// Khởi tạo kênh thông báo cho Android (Foreground)
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Đăng ký hàm xử lý background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Cấu hình hiển thị thông báo khi app đang mở (Foreground)
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel =  AndroidNotificationChannel(
    StringUtils.idChannel, // id
    StringUtils.titleChannel, // title
    description: StringUtils.descriptionChannel, // description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget{
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}
class _TodoAppState extends State<TodoApp> {

  @override
  void initial(){
    super.initState();
    _setupFcm();
  }

  Future<void> _setupFcm() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //Xin quyền thông báo
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Người dùng đã cấp quyền thông báo thành công!');

      String? token = await messaging.getToken();
      print("FCM Token của thiết bị: $token");

      //foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher', // Đảm bảo icon này tồn tại
              ),
            ),
          );
        }
      });

      //background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Người dùng vừa bấm vào thông báo từ Background!');

      });
    }
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