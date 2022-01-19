import 'package:auto_picker/models/Location.dart';

class Mechanic {
  String workingAddress;
  String id;
  String workingCity;
  String workingTime_To;
  String workingTime_From;
  String specialist;
  String accountCreatedDate;
  bool isBlocked;
  String location_lat;
  String location_lon;

  Mechanic(
      this.workingAddress,
      this.id,
      this.workingCity,
      this.workingTime_To,
      this.workingTime_From,
      this.specialist,
      this.accountCreatedDate,
      this.isBlocked,
      this.location_lat,
      this.location_lon);

  void updateId(String id) {
    this.id = id;
  }

  String getId() {
    return this.id;
  }

  factory Mechanic.fromJson(dynamic json) {
    return Mechanic(
      json["workingAddress"],
      json["id"],
      json["workingCity"],
      json["workingTime_To"],
      json["workingTime_From"],
      json["specialist"],
      json["accountCreatedDate"],
      json["isBlocked"],
      json["location_lat"],
      json["location_lon"],
    );
  }

  Map<String, Object> toJson() {
    return {
      'workingAddress': workingAddress,
      'id': id,
      'workingCity': workingCity,
      'workingTime_To': workingTime_To,
      'workingTime_From': workingTime_From,
      'specialist': specialist,
      'accountCreatedDate': accountCreatedDate,
      'isBlocked': isBlocked,
      'location_lat': location_lat,
      'location_lon': location_lon,
    };
  }
}
