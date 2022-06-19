import 'dart:convert';
import 'dart:io' show Platform;

import 'package:auto_picker/models/vehicle_service_remainder_notification.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notifications_service.dart';

const String channel_id = "123";

class NotificationServiceImpl {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void init(
      Future<dynamic> Function(int, String, String, String) onDidReceive) {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    initializeLocalNotificationsPlugin(initializationSettings);

    tz.initializeTimeZones();
  }

  void initializeLocalNotificationsPlugin(
      InitializationSettings initializationSettings) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    handleApplicationWasLaunchedFromNotification("");
  }

  Future selectNotification(String payload) async {
    //  UserBirthday userBirthday = getUserBirthdayFromPayload(payload ?? '');
    // cancelNotificationForBirthday(userBirthday);
    //scheduleNotificationForBirthday(userBirthday, "${userBirthday.name} has an upcoming birthday!");
  }

  void showNotification(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        vehicleServiceRemainderNotification.hashCode,
        applicationName,
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                channelDescription: 'To remind you about Service date')),
        payload: jsonEncode(vehicleServiceRemainderNotification));
  }

  void scheduleNotificationServieDate(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage,
      DateTime remainderDate) async {
    DateTime now = DateTime.now();
    //  DateTime birthdayDate = DateTime.now().add(Duration(minutes: 1));
    Duration difference = now.isAfter(remainderDate)
        ? now.difference(remainderDate)
        : remainderDate.difference(now);
/*
    bool didApplicationLaunchFromNotification =
        await _wasApplicationLaunchedFromNotification();
    if (didApplicationLaunchFromNotification && difference.inDays == 0) {
      scheduleNotificationForNextYear(
          vehicleServiceRemainderNotification, notificationMessage);
      return;
    } else if (!didApplicationLaunchFromNotification &&
        difference.inDays == 0) {
      showNotification(
          vehicleServiceRemainderNotification, notificationMessage);
      return;
    }*/

    await flutterLocalNotificationsPlugin.zonedSchedule(
        vehicleServiceRemainderNotification.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                channelDescription:
                    'To remind you about upcoming vehicle service dates')),
        payload: (vehicleServiceRemainderNotification).body,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void scheduleNotificationForNextYear(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        vehicleServiceRemainderNotification.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(new Duration(days: 365)),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                channelDescription: 'To remind you about upcoming birthdays')),
        payload: jsonEncode(vehicleServiceRemainderNotification),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotificationForBirthday(
      VehicleServiceRemainderNotification
          vehicleServiceRemainderNotification) async {
    await flutterLocalNotificationsPlugin
        .cancel(vehicleServiceRemainderNotification.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleApplicationWasLaunchedFromNotification(String payload) async {
    if (Platform.isIOS) {
      _rescheduleNotificationFromPayload(payload);
      return;
    }

    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      _rescheduleNotificationFromPayload(
          notificationAppLaunchDetails.payload ?? "");
    }
  }

  VehicleServiceRemainderNotification getUserBirthdayFromPayload(
      String payload) {
    Map<String, dynamic> json = jsonDecode(payload);
    VehicleServiceRemainderNotification userBirthday =
        VehicleServiceRemainderNotification.fromJson(json);
    return userBirthday;
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null) {
      return notificationAppLaunchDetails.didNotificationLaunchApp;
    }

    return false;
  }

  void _rescheduleNotificationFromPayload(String payload) {
    VehicleServiceRemainderNotification vehicleServiceRemainderNotification =
        getUserBirthdayFromPayload(payload);
    cancelNotificationForBirthday(vehicleServiceRemainderNotification);
    scheduleNotificationForNext(vehicleServiceRemainderNotification,
        "${vehicleServiceRemainderNotification.title} has an upcoming birthday!");
  }

  Future<List<PendingNotificationRequest>>
      getAllScheduledNotifications() async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  @override
  void cancelNotification(
      VehicleServiceRemainderNotification
          vehicleServiceRemainderNotificationy) {
    // TODO: implement cancelNotification
  }

  @override
  VehicleServiceRemainderNotification getUserVehicleServiceRemainderFromPayload(
      String payload) {
    // TODO: implement getUserVehicleServiceRemainderFromPayload
    throw UnimplementedError();
  }

  @override
  void scheduleNotificationForNext(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage) {
    // TODO: implement scheduleNotificationForNext
  }

  @override
  void scheduleNotificationForVehicleService(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage) {
    // TODO: implement scheduleNotificationForVehicleService
  }
}
