import 'package:auto_picker/models/fuel_alert.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelPushMessageCityPreferenceController {
  static CollectionReference fuelCityPreferencesList = FirebaseFirestore
      .instance
      .collection(FirebaseCollections.FuelCityPreferencesList);

  Future<bool> addFuelCityPref(List<String> citys, String uid) async {
    var res = false;
    await fuelCityPreferencesList
        .doc(uid)
        .set({"citys": citys})
        .then((value) => {res = true})
        .catchError(
            (error) => {res = false, print("Failed to add fuel city: $error")});
    return res;
  }

  getFuelAlertsCityPref(String uid) async {
    var res;
    await fuelCityPreferencesList
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        res = documentSnapshot.data();
      } else {
        print('Document does not exist on the database');
        res = null;
      }
    });
    return res;
  }

/*
  Future<bool> deleteFuelAlert(String uid) async {
    await fuelAlertlist.doc(uid).delete().then((value) {
      print("FuelAlert:deleted");
      return true;
    }).catchError((onError) {
      print("FuelAlert:deleted:error: $onError");
      return true;
    });
  }*/
}
