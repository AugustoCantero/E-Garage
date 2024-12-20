


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{

  static Future<void> requestPermissionLocalNotifications() async {

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }
  static Future<void> initializeLocalNotifications() async{

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');


    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data
  }){
    const androidDetails = AndroidNotificationDetails(
    'channelId',
    'channelName',
    playSound: true,
    importance: Importance.max,
    priority:Priority.high
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      id, 
      title, 
      body, 
      notificationDetails);
  }

  

  




}