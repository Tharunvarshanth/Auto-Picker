class SpareAdvertisement {
  String uid;
  bool isRemoved;
  bool isPaymentDone;
  String createdDate;
  String endDate;
  String payment;
  String price;
  String description;
  String title;
  String subtitle;
  List<String> imageList;

  SpareAdvertisement(
      this.uid,
      this.isRemoved,
      this.isPaymentDone,
      this.createdDate,
      this.endDate,
      this.payment,
      this.price,
      this.description,
      this.title,
      this.subtitle,
      this.imageList);

  factory SpareAdvertisement.fromJson(dynamic json) {
    return SpareAdvertisement(
        json["uid"],
        json["isRemoved"],
        json["isPaymentDone"],
        json["createdDate"],
        json["endDate"],
        json["payment"],
        json["price"],
        json["description"],
        json["title"],
        json["subtitle"],
        json["imageList"]);
  }

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'isRemoved': isRemoved,
      'isPaymentDone': isPaymentDone,
      'createdDate': createdDate,
      'endDate': endDate,
      'payment': payment,
      'price': price,
      'description': description,
      'title': title,
      'subtitle': subtitle,
      'imageList': imageList
    };
  }
}
