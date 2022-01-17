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

  Map<String, Object> toJson() {
    return {
      'workingAddress': workingAddress,
      'id': id,
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
