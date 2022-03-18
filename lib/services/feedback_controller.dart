import 'package:auto_picker/models/feedback_data.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBackController {
  static CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.Feedbacks);

  Future<bool> addFeedback(FeedBackData feedback, String uid) async {
    await feedbackCollection
        .doc(uid)
        .collection(FirebaseCollections.FeedbackList)
        .doc()
        .set(feedback.toJson())
        .then((value) {
      print("addFeedback:success");
      return true;
    }).catchError((onError) {
      print("addFeedback: $onError");
      return false;
    });
  }

  getFeedbackList(String id) async {
    return await feedbackCollection
        .doc(id)
        .collection(FirebaseCollections.FeedbackList)
        .get();
  }

  Future<dynamic> addTestAdvertisment(String uId) async {
    var res;
    await feedbackCollection.doc(uId).set({'test': 'test'}).then((value) {
      print("addSpareAdvertisement:success");
      res = true;
    }).catchError((onError) {
      print("addSpareAdvertisement: $onError");
      res = null;
    });
    return res;
  }

  Future<bool> updateFeedback(
      FeedBackData feedback, String uid, String msgId) async {
    await feedbackCollection
        .doc(uid)
        .collection(FirebaseCollections.FeedbackList)
        .doc(msgId)
        .update(feedback.toJson())
        .then((value) {
      print("updateFeedback:success");
      return true;
    }).catchError((onError) {
      print("updateFeedback:error: $onError");
      return true;
    });
  }

  // Refactor
  Future<bool> deleteFeedBack(String uid) async {
    await feedbackCollection.doc(uid).delete().then((value) {
      print("updateSellers:deleted");
      return true;
    }).catchError((onError) {
      print("updateSellers:deleted:error: $onError");
      return true;
    });
  }

  Future<Seller> getFeedback(String uid) async {
    await feedbackCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  Future<List<Seller>> getFeedbacks() async {
    await feedbackCollection
        .doc()
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }
}
