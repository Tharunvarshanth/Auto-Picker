class Seller {
  String shopName;
  String id;
  String address;
  String city;
  String contactDetails;
  String accountCreatedDate;
  bool isBlocked;

  Seller(
    this.shopName,
    this.id,
    this.address,
    this.city,
    this.contactDetails,
    this.accountCreatedDate,
    this.isBlocked,
  );

  void updateId(String id) {
    this.id = id;
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
    };
  }
}
