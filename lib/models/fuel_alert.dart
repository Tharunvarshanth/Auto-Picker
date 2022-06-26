class FuelAlert {
  String timeStamp;
  String message;
  String senderId;
  String fillingStationLat;
  String fillingStationLon;
  String city;
  bool diesel;
  bool petrol;

  FuelAlert(this.timeStamp, this.message, this.senderId, this.fillingStationLat,
      this.fillingStationLon, this.city, this.diesel, this.petrol);

  Map<String, Object> toJson() {
    return {
      'timeStamp': timeStamp,
      'message': message,
      'senderId': senderId,
      'fillingStationLat': fillingStationLat,
      'fillingStationLon': fillingStationLon,
      'city': city,
      'diesel': diesel,
      'petrol': petrol
    };
  }

  factory FuelAlert.fromJson(dynamic json) {
    return FuelAlert(
        json["timeStamp"],
        json["message"],
        json["senderId"],
        json["fillingStationLat"],
        json["fillingStationLon"],
        json["city"],
        json["diesel"],
        json["petrol"]);
  }
}
