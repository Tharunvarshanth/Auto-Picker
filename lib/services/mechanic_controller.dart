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

  Future<Mechanic> getMechanic(String uid) async {
    await mechanics.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  Future<List<Mechanic>> getMechanics() async {
    await mechanics.doc().get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  Future<bool> updateMechanic(Mechanic mechanic) async {
    await mechanics
        .doc(mechanic.getId())
        .update(mechanic.toJson())
        .then((value) {
      print("updateMechanic:success");
      return true;
    }).catchError((onError) {
      print("updateMechanic:error: $onError");
      return true;
    });
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
