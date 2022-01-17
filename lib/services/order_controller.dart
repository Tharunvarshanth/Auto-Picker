import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController {
  static CollectionReference orders =
      FirebaseFirestore.instance.collection(FirebaseCollections.Orders);

  Future<bool> addOrder(Order order, String uid) async {
    await orders
        .doc(uid)
        .collection(FirebaseCollections.OrdersList)
        .doc()
        .set(order.toJson())
        .then((value) {
      print("addOrder:success");
      return true;
    }).catchError((onError) {
      print("addOrder: $onError");
      return false;
    });
  }

  Future<dynamic> updateOrder(String oId, String uId, Order order) async {
    return await orders
        .doc(uId)
        .collection(FirebaseCollections.OrdersList)
        .doc(oId)
        .update(order.toJson())
        .whenComplete(() {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<dynamic> getOrdersBySeller(String Uid) async {
    return await orders
        .doc(Uid)
        .collection(FirebaseCollections.OrdersList)
        .get();
  }

  Future<dynamic> getOrderBySeller(String Uid, String oId) async {
    return await orders
        .doc(Uid)
        .collection(FirebaseCollections.OrdersList)
        .doc(oId)
        .get();
  }

  Future<dynamic> getOrderByCustomer(String customId) async {
    return await orders
        .doc()
        .collection(FirebaseCollections.OrdersList)
        .where('customerId', isEqualTo: customId)
        .get();
  }
}
