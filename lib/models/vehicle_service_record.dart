class VehicleService {
  String serviceId;
  String date;
  String notificationDate;
  bool isNotificationSented;
  String description;
  String mileage;

  VehicleService(
    this.serviceId,
    this.date,
    this.notificationDate,
    this.isNotificationSented,
    this.description,
    this.mileage,
  );

  void updateId(String id) {
    this.serviceId = id;
  }

  factory VehicleService.fromJson(dynamic json) {
    return VehicleService(
      json["serviceId"],
      json["date"],
      json["notificationDate"],
      json["isNotificationSented"],
      json["description"],
      json["mileage"],
    );
  }

  Map<String, Object> toJson() {
    return {
      'serviceId': serviceId,
      'date': date,
      'notificationDate': notificationDate,
      'isNotificationSented': isNotificationSented,
      'description': description,
      'mileage': mileage,
    };
  }
}
