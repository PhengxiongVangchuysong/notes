// reference: https://blog.codemagic.io/flutter-local-notifications/

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_init;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // this is singleton pattern, if you want know more, click here = https://flutterbyexample.com/lesson/singletons
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  late final FlutterLocalNotificationsPlugin _localNotifications;

  /// set up permissions, register receiver, initialize local notification.
  Future<void> setup(FlutterLocalNotificationsPlugin localNotification) async {
    _localNotifications = localNotification;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    // request ios permission
    const initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true);
    // create setting for local notification
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    // create local notification and register notification receiver
    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  /// listen on local notification when user clicks on it.
  void selectNotification(NotificationResponse payload) {
    // show payload of local notification
    debugPrint(payload.payload);
  }

  /// create notification details
  Future<NotificationDetails> _notificationDetails() async {
    // need to create your own channel
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('channel id', 'channel name',
            priority: Priority.high);
    // nothing to do more on iOS
    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails();

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}
    // register notification detail
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    // create notification detail
    final noticeDetail = await _notificationDetails();
    // show local notifcation now
    await _localNotifications.show(
      id,
      title,
      body,
      noticeDetail,
      payload: payload,
    );
  }

  Future<void> showScheduledLocalNotification({
    required String title,
    required String body,
    required String payload,
    required int endTime,
  }) async {
    // set time zone
    tz_init.initializeTimeZones();

    // set time to show notification
    // note if you want modify time, just change on duration and selete time unit that you want to use
    final scheduleTime =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: endTime));

    // create local notification detail
    final platformChannelSpecifics = await _notificationDetails();
    // set up id
    const int id = 0;
    // show notification when schedule time is matching
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      platformChannelSpecifics,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  // show notification every minute
  Future<void> showPeriodicLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }
}
