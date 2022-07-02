/*class City {
  String city;
  String code;

  City({this.city, this.code});

  City.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    code = json["code"];
  }
}*/

class City {
  String city;
  String code;

  City({this.city, this.code});

  City.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    code = json["code"];
  }

  static List<City> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => City.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String cityAsString() {
    return '#${this.code} ${this.city}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(City model) {
    return this?.city == model?.city;
  }

  @override
  String toString() => city;
}
