import 'dart:convert';
import 'package:auto_picker/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoCache {
  static const String userKey = "user";

  saveUser(bool isLogged, String userId, String mobileNumber, String email,
      String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userObject = {
      "isLogged": isLogged,
      "userId": userId,
      "phoneNumber": mobileNumber,
      "email": email,
      "role": role
    };
    print(userObject);
    String user = jsonEncode(Account.fromJson(userObject));
    print("user:converted" + user);
    prefs.setString(userKey, user);
  }

  Future<Object> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString(userKey);
    if (userString == null) {
      return null;
    }
    Map userMap = jsonDecode(prefs.getString(userKey));
    Account account = Account.fromJson(userMap);
    return account;
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString(userKey);
    if (userString == null) {
      return null;
    }
    Map userMap = jsonDecode(prefs.getString(userKey));
    Account account = Account.fromJson(userMap);
    return account.userId;
  }

  Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString(userKey);
    if (userString == null) {
      return null;
    }
    Map userMap = jsonDecode(prefs.getString(userKey));
    Account account = Account.fromJson(userMap);
    return account.role;
  }

  clearValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userKey);
  }
}
