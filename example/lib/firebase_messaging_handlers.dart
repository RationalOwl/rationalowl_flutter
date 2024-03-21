import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rationalowl_flutter/rationalowl_flutter.dart';

import 'local_notifications.dart';

Future<void> handleTokenRefresh(String token) async {
  log('handleTokenRefresh(token: $token)');

  final MinervaManager minMgr = MinervaManager.getInstance();
  minMgr.setDeviceToken(token);
}

@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage message) async {
  log('handleMessage(message: ${message.data})');

  final Map<String, dynamic> data = message.data;

  // set notification  delivery tracking
  final MinervaManager minMgr = MinervaManager.getInstance();
  minMgr.enableNotificationTracking(data: data);

  // silent push received.
  if (data.containsKey('silent')) {
    // system push is sent by RationalOwl for device app lifecycle check.
    // system push is also silent push.
    // if system push has received, just return.
    if (data.containsKey('SystemPush')) {
      log('System push received!', name: (handleMessage).toString());
      return;
    }
    // normal silent push which are sent by your app server.
    // do your logic
    else {
      log('your app server sent silent push', name: (handleMessage).toString());
      // do your logic
    }
  }
  // it is normal custom push not silent push.
  // do your logic here
  else {
    // make your custom notification UI
    showNotification(data);
  }
}
