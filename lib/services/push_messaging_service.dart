import 'dart:convert';

import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushMessagingSerivce {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void foregroundMessageListner() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void mainFCMDeviceToken() {
    messaging.getToken();
  }

  String getFCMDeviceToken() {
    messaging.getToken().then((value) {
      return value;
    });
  }

  backgroundMessageListener() {
    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      print("Handling a background message: ${message.messageId}");
    }
  }

  void setOneSignalToken(String uid) async {
    var externalUserId =
        uid; // You will supply the external user id to the OneSignal SDK

// Setting External User Id with Callback Available in SDK Version 3.9.3+
    OneSignal.shared.setExternalUserId(externalUserId).then((results) {
      print(results.toString());
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<Response> sendOrderNotification(
      List<String> tokenIdList, String contents, String heading) async {
    await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic NTdmZjM0ZjEtNTQ0Ny00MTQ2LTg3M2UtNjZhNDA2NzY3ZTVj',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            ONESIGNALAPPID, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_external_user_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon":
            "https://firebasestorage.googleapis.com/v0/b/auto-picker-7ed1f.appspot.com/o/FCMImages%2Forder-now.png?alt=media&token=3ee171dd-966e-4a9a-b81c-c71d4fdd6c59",

        "large_icon":
            "https://firebasestorage.googleapis.com/v0/b/auto-picker-7ed1f.appspot.com/o/FCMImages%2Forder-now.png?alt=media&token=3ee171dd-966e-4a9a-b81c-c71d4fdd6c59",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    ).then((value) {
      print("sendNotification ${value.body}");
      return true;
    }).catchError((onError) {
      print("sendNotification:error $onError");
      return false;
    });
  }

  deviceTodevicePushMessage() async {}
}
