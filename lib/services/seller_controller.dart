import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerController {
  static CollectionReference sellers =
      FirebaseFirestore.instance.collection(FirebaseCollections.Sellers);

  Future<bool> addSeller(Seller seller) async {
    var res = false;
    await sellers.doc(seller.getId()).set(seller.toJson()).then((value) {
      print("addSeller:success");
      res = true;
    }).catchError((onError) {
      print("addSeller: $onError");
      res = false;
    });
    return res;
  }

  Future<bool> updateSeller(Seller seller) async {
    await sellers.doc(seller.getId()).update(seller.toJson()).then((value) {
      print("updateSeller:success");
      return true;
    }).catchError((onError) {
      print("updateSeller:error: $onError");
      return true;
    });
  }

  Future<bool> updateSellersField(
      String uid, String field, String value) async {
    await sellers.doc(uid).update({field: value}).then((value) {
      print("updateSellers:success");
      return true;
    }).catchError((onError) {
      print("updateSellers:error: $onError");
      return true;
    });
  }

  Future<bool> deleteUser(String uid) async {
    await sellers.doc(uid).delete().then((value) {
      print("updateSellers:deleted");
      return true;
    }).catchError((onError) {
      print("updateSellers:deleted:error: $onError");
      return true;
    });
  }

  getSeller(String uid) async {
    var res;
    await sellers.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        res = documentSnapshot.data();
      } else {
        res = null;
      }
    });
    return res;
  }

  Future<List<Seller>> getSellers() async {
    await sellers.doc().get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }
}
