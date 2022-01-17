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

  Future<bool> isAlreadyLogged(String number) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.Users)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["mobileNumber"]);
        if (doc["mobileNumber"] == number)
          return true;
        else
          return false;
      });
    });

    return null;
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

  Future<UserModel> getUser(String uid) async {
    await users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  Future<List<UserModel>> getUsers() async {
    await users.doc().get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return documentSnapshot;
      }
      return null;
    });
  }

  Future<bool> updateUser(UserModel user) async {
    await users.doc(user.getId()).update(user.toJson()).then((value) {
      print("updateSeller:success");
      return true;
    }).catchError((onError) {
      print("updateSeller:error: $onError");
      return true;
    });
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
}
