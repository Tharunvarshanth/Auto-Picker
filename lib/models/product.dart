class Product {
  String uid;
  String price;
  String title;
  String description;
  String condition;
  List<dynamic> imagesList;
  String pId;
  bool isPayed;
  String deletingDate;

  Product(this.uid, this.price, this.title, this.description, this.condition,
      this.imagesList, this.pId, this.isPayed, this.deletingDate);

  void updateId(String id) {
    this.uid = id;
  }

  factory Product.fromJson(dynamic json) {
    return Product(
        json["uid"],
        json["price"],
        json["title"],
        json["description"],
        json["condition"],
        json["imagesList"] as List<dynamic>,
        json["pId"],
        json["isPayed"],
        json["deletingDate"]);
  }

  String getUId() {
    return this.uid;
  }

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'price': price,
      'title': title,
      'description': description,
      'condition': condition,
      'imagesList': imagesList,
      'pId': pId,
      'isPayed': isPayed,
      'deletingDate': deletingDate
    };
  }
}
