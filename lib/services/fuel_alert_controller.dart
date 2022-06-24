import 'package:auto_picker/models/fuel_alert.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelAlertController {
  static CollectionReference fuelAlertlist =
      FirebaseFirestore.instance.collection(FirebaseCollections.FuelAlertList);

  Future<bool> addFuelAlert(FuelAlert fa) async {
    // Call the user's CollectionReference to add a new user
    var res = false;
    await fuelAlertlist
        .doc()
        .set(fa.toJson())
        .then((value) => {res = true})
        .catchError((error) =>
            {res = false, print("Failed to add fuel status: $error")});
    return res;
  }

  Future<dynamic> getFuelAlerts() async {
    QuerySnapshot querySnapshot = await fuelAlertlist.get();
    if (querySnapshot.size > 0) {
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    }
    return null;
  }

  Future<bool> deleteFuelAlert(String uid) async {
    await fuelAlertlist.doc(uid).delete().then((value) {
      print("FuelAlert:deleted");
      return true;
    }).catchError((onError) {
      print("FuelAlert:deleted:error: $onError");
      return true;
    });
  }
}
