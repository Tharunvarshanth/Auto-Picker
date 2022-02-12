import 'dart:async';

import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController {
  static CollectionReference products =
      FirebaseFirestore.instance.collection(FirebaseCollections.Products);

  Future<dynamic> addProduct(Product product) async {
    var res;
    await products
        .doc(product.getUId())
        .collection(FirebaseCollections.ProductsList)
        .add(product.toJson())
        .then((value) {
      print("add product ${value.id}");
      res = value.id;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = null;
    });
    return res;
  }

  Future<dynamic> addFirstTimeSignup(String uid) async {
    return await products.doc(uid).set({'test': 'data'});
  }

  getRecentlyAddedProduct(String uid, Product product) async {
    var res;
    await products
        .doc(uid)
        .collection(FirebaseCollections.ProductsList)
        .where('imagesList', isNull: true)
        .get();
  }

//Need to do like this https://github.com/sbis04/flutterfire-samples/blob/crud-firestore/lib/widgets/item_list.dart
  Future<dynamic> getProduct(String uid, String pId) async {
    return await products
        .doc(uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(pId)
        .get();
  }

  //Need to do like this https://github.com/sbis04/flutterfire-samples/blob/crud-firestore/lib/widgets/item_list.dart
  Future<QuerySnapshot> getProducts() async {
    return await products.get();
    /*
    if (res1 != null) {
      res1.docs.forEach((element) async {
        QuerySnapshot res2 = await element.reference
            .collection(FirebaseCollections.ProductsList)
            .get();
        if (res2 != null) {
          print(res2);
          res2.docs.forEach((element) {
            prodList.add(Product.fromJson(element.data()));
          });
        }
      });
/*
    await products.get().then((QuerySnapshot querySnapshot) async {
      querySnapshot.docs.forEach((element) async {
        await element.reference
            .collection(FirebaseCollections.ProductsList)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((element) {
            prodList.add(Product.fromJson(element.data()));
          });
        });
      });
    });
*/
      Timer(Duration(seconds: 8), () {
        print("Yeah, this line is printed after 3 seconds");
        return prodList;
      });
    }*/
  }

  Future<dynamic> getUserProducts(String Uid) async {
    return await products
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .get();
  }

  Future<dynamic> updateProduct(
      String Uid, String pId, String field, dynamic imageList) async {
    var res;
    await products
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(pId)
        .update({field: imageList}).whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> updateProductAllField(Product product) async {
    var res = false;
    await products
        .doc(product.uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(product.pId)
        .update(product.toJson())
        .whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> deleteProduct(Product product) async {
    var res = false;
    await products
        .doc(product.getUId())
        .collection(FirebaseCollections.ProductsList)
        .doc(product.pId)
        .delete()
        .then((value) {
      res = true;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = false;
    });
    return res;
  }

  Future<dynamic> addProductTest(String user) async {
    var res;
    await products.doc(user).set({"test": "test"}).then((value) {
      print("add product ");
      res = true;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = null;
    });
    return res;
  }
}
