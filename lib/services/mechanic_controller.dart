import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicController {
  static CollectionReference mechanics =
      FirebaseFirestore.instance.collection(FirebaseCollections.Mechanics);

  Future<bool> addMechanic(Mechanic mechanic) async {
    var res = false;
    await mechanics.doc(mechanic.getId()).set(mechanic.toJson()).then((value) {
      print("addMechanic:success");
      res = true;
    }).catchError((onError) {
      print("addMechanic: $onError");
      res = false;
    });
    return res;
  }

  getMechanic(String uid) async {
    var res;
    await mechanics.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        res = documentSnapshot.data();
      } else {
        res = false;
      }
    });
    return res;
  }

  Future<dynamic> getMechanics() async {
    QuerySnapshot querySnapshot = await mechanics.get();
    if (querySnapshot.size > 0) {
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    }
    return null;
  }

  Future<bool> updateMechanic(Mechanic mechanic) async {
    var res = false;
    await mechanics
        .doc(mechanic.getId())
        .update(mechanic.toJson())
        .then((value) {
      print("updateMechanic:success");
      res = true;
    }).catchError((onError) {
      print("updateMechanic:error: $onError");
      res = false;
    });
    return res;
  }

  Future<bool> updateMechanicsField(
      String uid, String field, String value) async {
    await mechanics.doc(uid).update({field: value}).then((value) {
      print("updateMechanic:success");
      return true;
    }).catchError((onError) {
      print("updateMechanic:error: $onError");
      return true;
    });
  }

  Future<bool> deleteUser(String uid) async {
    await mechanics.doc(uid).delete().then((value) {
      print("updateMechanic:deleted");
      return true;
    }).catchError((onError) {
      print("updateMechanic:deleted:error: $onError");
      return true;
    });
  }
}
