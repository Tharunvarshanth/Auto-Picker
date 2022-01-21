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

  Future<dynamic> getAdvertisments() async {
    return await advertisements
        .doc()
        .collection(FirebaseCollections.AdvertisementList)
        .get();
  }

  Future<dynamic> getAdvertisementsBySeller(String Uid) async {
    return await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.AdvertisementList)
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
}
