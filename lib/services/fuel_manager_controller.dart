import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelManagerController {
  static CollectionReference fuelManagers =
      FirebaseFirestore.instance.collection(FirebaseCollections.FuelManager);
}
