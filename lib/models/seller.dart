class Seller {
  String shopName;
  String id;
  String address;
  String city;
  String contactDetails;
  String accountCreatedDate;
  bool isBlocked;
  bool isPayed;
  Seller(this.shopName, this.id, this.address, this.city, this.contactDetails,
      this.accountCreatedDate, this.isBlocked, this.isPayed);

  void updateId(String id) {
    this.id = id;
  }

  factory Seller.fromJson(dynamic json) {
    return Seller(
        json["shopName"],
        json["id"],
        json["address"],
        json["city"],
        json["contactDetails"],
        json["accountCreatedDate"],
        json["isBlocked"],
        json["isPayed"]);
  }

  String getId() {
    return this.id;
  }

  Map<String, Object> toJson() {
    return {
      'shopName': shopName,
      'id': id,
      'address': address,
      'city': city,
      'contactDetails': contactDetails,
      'accountCreatedDate': accountCreatedDate,
      'isBlocked': isBlocked,
      'isPayed': isPayed
    };
  }
}
