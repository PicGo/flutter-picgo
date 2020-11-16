import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationUtil {
  static LocalNotificationUtil _instance;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationAppLaunchDetails _notificationAppLaunchDetails;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  NotificationAppLaunchDetails get notificationAppLaunchDetails =>
      _notificationAppLaunchDetails;

  LocalNotificationUtil._();

  /// 必须先调用
  initialization() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // notification
    _notificationAppLaunchDetails = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false, //初始化不请求权限
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: new MacOSInitializationSettings());
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  /// 需要先请求权限
  requestPermissions() {
    /// iOS获取权限
    if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(AndroidNotificationChannel(
              AndroidChannelId.upload_channel, '通知提示', '上传通知提示'));
    }
  }

  /// 显示
  show(int id, String title, String body,
      NotificationDetails notificationDetails) async {
    await _flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  /// 实例获取
  static LocalNotificationUtil getInstance() {
    if (_instance == null) {
      _instance = LocalNotificationUtil._();
    }
    return _instance;
  }

  /// 上传Channel
  static AndroidNotificationDetails uploadAndroidChannel() {
    return AndroidNotificationDetails(
        AndroidChannelId.upload_channel, '上传通知', '上传通知提示',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  }

  /// 默认IOS
  static IOSNotificationDetails normalIOSNotificationDetails() {
    return IOSNotificationDetails();
  }

  /// 默认MacOS
  static MacOSNotificationDetails normalMacOSNotificationDetails() {
    return MacOSNotificationDetails();
  }

  static NotificationDetails createNotificationDetails(
      AndroidNotificationDetails android, IOSNotificationDetails iOS, MacOSNotificationDetails macOS) {
    return NotificationDetails(android: android, iOS: iOS, macOS: macOS);
  }
}

class AndroidChannelId {
  static const upload_channel = '10000';
}
