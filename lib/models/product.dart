class Product {
  String uid;
  String price;
  String description;
  String title;
  String subtitle;
  String city;
  String condition;
  List<String> imagesList;

  Product(this.uid, this.price, this.description, this.title, this.subtitle,
      this.city, this.condition, this.imagesList);

  void updateId(String id) {
    this.uid = id;
  }

  factory Product.fromJson(dynamic json) {
    return Product(
        json["uid"],
        json["price"],
        json["description"],
        json["title"],
        json["subtitle"],
        json["city"],
        json["condition"],
        json["imagesList"]);
  }

  String getUId() {
    return this.uid;
  }

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'price': price,
      'description': description,
      'title': title,
      'subtitle': subtitle,
      'city': city,
      'condition': condition,
      'imagesList': imagesList
    };
  }
}
