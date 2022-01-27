class Product {
  String uid;
  String price;
  String title;
  String description;
  String condition;
  List<dynamic> imagesList;
  String pId;

  Product(this.uid, this.price, this.title, this.description, this.condition,
      this.imagesList, this.pId);

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
        json["pId"]);
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
      'pId': pId
    };
  }
}
