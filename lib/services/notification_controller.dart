import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicController {
  static CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.Notifications);
  var userInfo = new UserInfoCache();

  Future<bool> addNotification(Notification notification, String uid) async {
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

  Future<List<Seller>> getNotifications(String uid) async {
    String uid = await userInfo.getId();
    notificationCollection
        .doc(uid)
        .collection(FirebaseCollections.NotificationsList)
        .doc()
        .get()
        .then((value) => print(value))
        .onError((error, stackTrace) => null);
  }
}
