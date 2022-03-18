class VehicleServiceRemainderNotification {
  final int id;
  final String title;
  final String body;
  bool hasNotification;
  VehicleServiceRemainderNotification(
      this.id, this.title, this.body, this.hasNotification);

  factory VehicleServiceRemainderNotification.fromJson(dynamic json) {
    return VehicleServiceRemainderNotification(
      json["id"],
      json["title"],
      json["body"],
      json["hasNotification"],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        id: id,
        title: title,
        body: body,
        hasNotification: hasNotification,
      };
}
