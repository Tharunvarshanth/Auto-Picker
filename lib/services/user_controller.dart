import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  static CollectionReference users =
      FirebaseFirestore.instance.collection(FirebaseCollections.Users);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUserFromServer() {
    print("Home Page Auth Current user: ${_auth.currentUser}");
    return _auth.currentUser;
  }

  Future<bool> addUser(UserModel user) async {
    // Call the user's CollectionReference to add a new user
    var res = false;
    await users
        .doc(user.getId())
        .set(user.toJson())
        .then((value) => {res = true})
        .catchError(
            (error) => {res = false, print("Failed to add user: $error")});
    return res;
  }

  Future<bool> isNumberAlreadyHaveAccount(String phoneNumber) async {
    var res = false;
    await users
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        res = true;
      } else {
        res = false;
      }
    });
    return res;
  }

  getUser(String uid) async {
    var res;
    print("Tharunu" + uid);
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.exists);
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        res = documentSnapshot.data();
      } else {
        print('Document does not exist on the database thaun');
        res = false;
      }
    });
    return res;
  }

  Future<dynamic> getUsers() async {
    QuerySnapshot querySnapshot = await users.get();
    if (querySnapshot.size > 0) {
      final data = querySnapshot.docs.map((doc) => doc.data()).toList();
      return data;
    }
    return null;
  }

  Future<bool> updateUser(UserModel user) async {
    var res = false;
    await users.doc(user.getId()).update(user.toJson()).then((value) {
      print("updateSeller:success");
      res = true;
    }).catchError((onError) {
      print("updateSeller:error: $onError");
      res = true;
    });
    return res;
  }

  Future<bool> updateUserField(String uid, String field, String value) async {
    await users.doc(uid).update({field: value}).then((value) {
      print("updateSellers:success");
      return true;
    }).catchError((onError) {
      print("updateSellers:error: $onError");
      return true;
    });
  }

  Future<bool> deleteUser(String uid) async {
    await users.doc(uid).delete().then((value) {
      print("updateSellers:deleted");
      return true;
    }).catchError((onError) {
      print("updateSellers:deleted:error: $onError");
      return true;
    });
  }

  Future<Users> getSeller(String uid) async {
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  getUserForCustomerOrder(String uid) async {
    var res;
    print("Tharun " + uid);
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.exists);
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        res = documentSnapshot.data();
        return res;
      } else {
        print('Document does not exist on the database thaun');
        res = false;
      }
    });
    return res;
  }
}
