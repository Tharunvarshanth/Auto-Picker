import 'package:auto_picker/models/vehicle_service_record.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleServiceController {
  static CollectionReference vehicleService = FirebaseFirestore.instance
      .collection(FirebaseCollections.VehicleServiceMaintenance);

  Future<QuerySnapshot> getVehicleServiceRecords(String uid) async {
    return await vehicleService
        .doc(uid)
        .collection(FirebaseCollections.VehicleServiceList)
        .get();
  }

  Future<dynamic> addvehicleService(
      VehicleService vehicleServiceRecord, String id) async {
    var res;
    await vehicleService
        .doc(id)
        .collection(FirebaseCollections.VehicleServiceList)
        .add(vehicleServiceRecord.toJson())
        .then((value) {
      print("add service ${value.id}");
      res = value.id;
    }).catchError((onError) {
      print("add service: $onError");
      res = null;
    });
    return res;
  }

  Future<dynamic> updateServiceRecord(
      String Uid, String pId, String field, dynamic value) async {
    var res;
    await vehicleService
        .doc(Uid)
        .collection(FirebaseCollections.VehicleServiceList)
        .doc(pId)
        .update({field: value}).whenComplete(() {
      res = true;
    }).onError((error, stackTrace) {
      res = false;
    });
    return res;
  }

  Future<dynamic> addVehicleServiceTest(String user) async {
    var res;
    await vehicleService.doc(user).set({"test": "test"}).then((value) {
      print("add product ");
      res = true;
    }).catchError((onError) {
      print("addProduct: $onError");
      res = null;
    });
    return res;
  }
}
