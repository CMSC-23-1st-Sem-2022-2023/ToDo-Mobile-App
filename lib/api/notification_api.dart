/*
  Created by: Roxanne Ysabel Resuello
  Date: 21 November 2022
  Description: A shared todo flutter app that uses firebase with the following features:
                1. Add, delete, and edit a todo
                2. Add and delete a friend
                3. Accept and decline a friend request
                4. Sign in, Login, and Logout an account
                5. View profile
                6. View friend's profile
*/

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  NotificationApi();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  // Initialize notification settings
  Future<void> intialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      //onSelectNotification: onSelectNotification,
    );
  }

  // Set up notification details
  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  // Function for showing notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }
}
