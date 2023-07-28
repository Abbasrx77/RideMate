import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;
  final storage = const FlutterSecureStorage();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initLocalNotifications()async{
    const android = AndroidInitializationSettings('@drawable/logo_in_app');
    const settings = InitializationSettings(android: android);
    
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload){
        final message = RemoteMessage.fromMap(jsonDecode(payload as String));
        handleMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
    
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage()
        .then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/logo_in_app'
            ),
          ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  void handleMessage(RemoteMessage? message){
    if(message == null) return;

    //Navigation vers la page voulue avec arguments
  }

  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await storage.write(key: 'fcmToken', value: fCMToken);
    print("Token: $fCMToken");
    initPushNotifications();
    initLocalNotifications();
  }
}