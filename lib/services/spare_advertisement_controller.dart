import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementController {
  static CollectionReference advertisements =
      FirebaseFirestore.instance.collection(FirebaseCollections.Advertisement);

  Future<dynamic> addAdvertisment(
      String uId, SpareAdvertisement spareAdvertisement) async {
    var res;
    await advertisements
        .doc(uId)
        .collection(FirebaseCollections.AdvertisementList)
        .add(spareAdvertisement.toJson())
        .then((value) {
      print("addSpareAdvertisement:success");
      res = value.id;
    }).catchError((onError) {
      print("addSpareAdvertisement: $onError");
      res = null;
    });
    return res;
  }

  Future<QuerySnapshot> getAdvertisments() async {
    return await advertisements.get();
  }

  Future<dynamic> getAdvertisementsBySeller(String Uid) async {
    return await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.AdvertisementList)
        .orderBy('createdDate', descending: true)
        .get();
  }

  Future<dynamic> updateAdvertisement(
      String Uid, String aId, String field, dynamic value) async {
    var res;
    await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.AdvertisementList)
        .doc(aId)
        .update({field: value}).whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> updateManyAdvertisement(
      String Uid, String aId, dynamic value) async {
    var res;
    await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.AdvertisementList)
        .doc(aId)
        .update(value)
        .whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> removeAdvertisement(String Uid, String aId) async {
    var res;
    await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.AdvertisementList)
        .doc(aId)
        .delete()
        .then((value) => res = true)
        .catchError((error) => res = false);

    return res;
  }

  Future<dynamic> addTestAdvertisment(String uId) async {
    var res;
    await advertisements
        .doc(uId)
        .set({"createdAt": DateTime.now().toLocal().toString()}).then((value) {
      print("addSpareAdvertisement:success");
      res = true;
    }).catchError((onError) {
      print("addSpareAdvertisement: $onError");
      res = null;
    });
    return res;
  }

  Future<dynamic> deleteProduct(SpareAdvertisement advertisement) async {
    var res = false;
    await advertisements
        .doc(advertisement.uid)
        .collection(FirebaseCollections.AdvertisementList)
        .doc(advertisement.aId)
        .delete()
        .then((value) {
      res = true;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = false;
    });
    return res;
  }

  Future<dynamic> updateAdvertisementAllField(
      SpareAdvertisement advertisement) async {
    var res = false;
    await advertisements
        .doc(advertisement.uid)
        .collection(FirebaseCollections.AdvertisementList)
        .doc(advertisement.aId)
        .update(advertisement.toJson())
        .whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }
}
