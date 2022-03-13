class VehicleServiceRecord {
  String serviceId;
  String date;
  String notificationDate;
  bool isNotificationSented;
  String description;
  String mileage;

  VehicleServiceRecord(
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
