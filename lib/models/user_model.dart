class UserModel {
  String fullName;
  String id;
  String phoneNumber;
  String email;
  String role;
  String userName;
  String city;
  String address;
  bool isBlocked;

  UserModel(this.fullName, this.id, this.phoneNumber, this.email, this.role,
      this.userName, this.city, this.address, this.isBlocked);

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      json["fullName"],
      json["id"],
      json["phoneNumber"],
      json["email"],
      json["role"],
      json["userName"],
      json["city"],
      json["address"],
      json["isBlocked"],
    );
  }

  void updateId(String id) {
    this.id = id;
  }

  String getId() {
    return this.id;
  }

  Map<String, Object> toJson() {
    return {
      'fullName': fullName,
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'role': role,
      'userName': userName,
      'city': city,
      'address': address,
      'isBlocked': isBlocked
    };
  }
}
