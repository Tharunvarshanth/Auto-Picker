class NotificationModel {
  String title;
  String message;
  String timeStamp;
  String messageType;

  NotificationModel(this.title, this.message, this.timeStamp, this.messageType);

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
        json["title"], json["message"], json["timeStamp"], json["messageType"]);
  }
  Map<String, Object> toJson() {
    return {
      'title': title,
      'message': message,
      'timeStamp': timeStamp,
      'messageType': messageType
    };
  }
}
