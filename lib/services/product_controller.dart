import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController {
  static CollectionReference products =
      FirebaseFirestore.instance.collection(FirebaseCollections.Products);

  Future<bool> addProduct(Product product) async {
    await products
        .doc(product.getUId())
        .collection(FirebaseCollections.ProductsList)
        .doc()
        .set(product.toJson())
        .then((value) {
      print("addProduct:success");
      return true;
    }).catchError((onError) {
      print("addProduct: $onError");
      return false;
    });
  }

//Need to do like this https://github.com/sbis04/flutterfire-samples/blob/crud-firestore/lib/widgets/item_list.dart
  Future<dynamic> getProduct(String uid, String pId) async {
    return await products
        .doc(uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(pId)
        .snapshots();
  }

  //Need to do like this https://github.com/sbis04/flutterfire-samples/blob/crud-firestore/lib/widgets/item_list.dart
  Future<dynamic> getProducts() async {
    return await products
        .doc()
        .collection(FirebaseCollections.ProductsList)
        .get();
  }

  Future<dynamic> getUserProducts(String Uid) async {
    return await products
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .get();
  }

  Future<dynamic> updateProduct(String Uid, String pId, Product product) async {
    return await products
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(pId)
        .update(product.toJson())
        .whenComplete(() {
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }
}
