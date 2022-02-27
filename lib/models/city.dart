class City {
  String city;
  String code;

  City({this.city, this.code});

  City.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    code = json["code"];
  }
}
