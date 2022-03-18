import 'package:auto_picker/models/vehicle_service_remainder_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  void init(Future<dynamic> Function(int, String, String, String) onDidReceive);
  Future selectNotification(String payload);
  void showNotification(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage);
  void scheduleNotificationForVehicleService(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage);
  void scheduleNotificationServieDate(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage,
      DateTime dateTime);
  void scheduleNotificationForNext(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotification,
      String notificationMessage);
  void cancelNotification(
      VehicleServiceRemainderNotification vehicleServiceRemainderNotificationy);
  void cancelAllNotifications();
  void handleApplicationWasLaunchedFromNotification(String payload);
  VehicleServiceRemainderNotification getUserVehicleServiceRemainderFromPayload(
      String payload);
  Future<List<PendingNotificationRequest>> getAllScheduledNotifications();
}
