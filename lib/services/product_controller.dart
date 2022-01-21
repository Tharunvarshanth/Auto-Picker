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

  Future<dynamic> updateProduct(
      String Uid, String pId, List<String> imageList) async {
    var res;
    await products
        .doc(Uid)
        .collection(FirebaseCollections.ProductsList)
        .doc(pId)
        .update({'imagesList': imageList}).whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }
}
