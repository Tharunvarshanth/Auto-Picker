import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController {
  static CollectionReference adminControls =
      FirebaseFirestore.instance.collection(FirebaseCollections.AdminControls);

  getAdmin() async {
    var res;
    await adminControls
        .doc('IWRgEPuAxwrcYwCGn3Dk')
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
}
