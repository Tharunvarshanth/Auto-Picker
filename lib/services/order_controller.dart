import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderController {
  static CollectionReference orders =
      FirebaseFirestore.instance.collection(FirebaseCollections.Orders);

  Future<dynamic> addOrder(
    Order order,
  ) async {
    var res = null;
    await orders
        .doc(order.sellerId)
        .collection(FirebaseCollections.OrdersList)
        .add(order.toJson())
        .then((value) {
      print("addOrder:success ${value.id}");
      res = value.id;
    }).catchError((onError) {
      print("addOrder: $onError");
      res = null;
    });
    return res;
  }

  Future<dynamic> updateOrderAllField(Order order) async {
    var res = false;
    await orders
        .doc(order.sellerId)
        .collection(FirebaseCollections.OrdersList)
        .doc(order.orderId)
        .update(order.toJson())
        .whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> addTestOrder(String uId) async {
    var res;
    await orders.doc(uId).set({'test': 'test'}).then((value) {
      print("addSpareAdvertisement:success");
      res = true;
    }).catchError((onError) {
      print("addSpareAdvertisement: $onError");
      res = null;
    });
    return res;
  }

  Future<bool> updateOrderField(
      Order order, String field, dynamic value) async {
    var res = false;
    await orders
        .doc(order.sellerId)
        .collection(FirebaseCollections.OrdersList)
        .doc(value)
        .update({field: value}).whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
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
