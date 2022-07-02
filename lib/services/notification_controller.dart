import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationController {
  static CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.Notifications);
  var userInfo = new UserInfoCache();

  Future<bool> addNotification(
      NotificationModel notification, String uid) async {
    await notificationCollection
        .doc(uid)
        .collection(FirebaseCollections.NotificationsList)
        .doc()
        .set(notification.toJson())
        .then((value) {
      print("addNotification:success");
      return true;
    }).catchError((onError) {
      print("addNotification: $onError");
      return false;
    });
  }

  Future<dynamic> addNotificationTest(String uid) async {
    var res;
    await notificationCollection
        .doc(uid)
        .set({"createdAt": DateTime.now().toLocal().toString()}).then((value) {
      print("add product ");
      res = true;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = null;
    });
    return res;
  }

  Future<dynamic> getNotifications(String uid) async {
    return await notificationCollection
        .doc(uid)
        .collection(FirebaseCollections.NotificationsList)
        .get();
  }
}
