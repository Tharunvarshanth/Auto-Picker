import 'package:flutter/cupertino.dart';

class Account {
  bool isLogged;
  String userId;
  String mobileNumber;
  String email;
  String role;

  Account(
      {this.isLogged, this.userId, this.mobileNumber, this.email, this.role});

  factory Account.fromJson(Map<String, dynamic> parsedJson) {
    return Account(
        isLogged: parsedJson['isLogged'] ?? false,
        userId: parsedJson['userId'] ?? "",
        mobileNumber: parsedJson["phoneNumber"] ?? "",
        email: parsedJson["email"] ?? "",
        role: parsedJson["role"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "isLogged": this.isLogged,
      "userId": this.userId,
      "phoneNumber": this.mobileNumber,
      "email": this.email,
      "role": this.role
    };
  }
}
