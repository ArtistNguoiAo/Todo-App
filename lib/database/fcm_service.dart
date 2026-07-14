

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/string_utils.dart';

AndroidNotificationChannel localChannel = AndroidNotificationChannel(
  StringUtils.idChannel, // id
  StringUtils.titleChannel, // title
  description: StringUtils.descriptionChannel,
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Nhận thông báo khi app đóng/nền: ${message.notification?.title}");

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          localChannel.id,
          localChannel.name,
          channelDescription: localChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

class FCMService {
  static Future<void> initNotifications() async{
// Đăng ký hàm xử lý background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Thiết lập cài đặt hiển thị thông báo ban đầu cho Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // Khởi chạy Plugin Local Notification
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Đăng ký Kênh thông báo này lên hệ điều hành Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(localChannel);
  }

  static Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //Xin quyền thông báo
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Người dùng đã cấp quyền thông báo thành công!');

      String? token = await messaging.getToken();
      print("FCM Token của thiết bị: $token");

      //foreground - app đang mở
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
                localChannel.id,
                localChannel.name,
                channelDescription: localChannel.description,
                importance: Importance.max, // Bật banner nổi lên trên màn hình
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Người dùng vừa bấm vào thông báo từ Background!');
      });
    }
  }
}