import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementController {
  static CollectionReference advertisements =
      FirebaseFirestore.instance.collection(FirebaseCollections.Advertisement);

  Future<bool> addAdvertisment(
      String uId, SpareAdvertisement spareAdvertisement) async {
    await advertisements
        .doc(uId)
        .collection(FirebaseCollections.AdvertisementList)
        .doc()
        .set(spareAdvertisement.toJson())
        .then((value) {
      print("addSpareAdvertisement:success");
      return true;
    }).catchError((onError) {
      print("addSpareAdvertisement: $onError");
      return false;
    });
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
      String Uid, String aId, SpareAdvertisement spareAdvertisement) async {
    return await advertisements
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(aId)
        .update(spareAdvertisement.toJson())
        .whenComplete(() {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
