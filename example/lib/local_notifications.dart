import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin? _localNotificationsPlugin;

const channel = AndroidNotificationChannel(
  'rationalowl_flutter_example', // ID
  'RationalOwl Flutter Example', // Title
  importance: Importance.max,
);

Future<void> initializeNotification() async {
  if (_localNotificationsPlugin != null) return;

  _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await _localNotificationsPlugin!.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
  );

  if (Platform.isAndroid) {
    final androidImplementation = _localNotificationsPlugin!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final bool? granted = await androidImplementation?.requestNotificationsPermission();

    if (granted == true) {
      androidImplementation?.createNotificationChannel(channel);
    }
  } else if (Platform.isIOS) {
    final iosImplementation = _localNotificationsPlugin!.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void showNotification(Map<String, dynamic> data) {
  // hello app custom data format can be any fields you want
  // this sample app assume below fields
  /*
  {
    "mId": "message id here",
    "title": "message title here",
    "body": "message body here",
    "ii": "image id here"
    "st": "(message) send time"
  }
  */

  // mandatory fields
  final String id = data['mId'];
  final String body = data['body'];

  // optional fields
  final String? title = data['title'];

  _localNotificationsPlugin?.show(
    id.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        priority: Priority.max,
      ),
    ),
  );
}
