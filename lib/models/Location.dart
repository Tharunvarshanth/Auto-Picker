class Location {
  String lat;
  String lon;
  Location({this.lat, this.lon});

  Map<String, Object> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}
