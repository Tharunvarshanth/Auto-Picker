class NotificationModel {
  String title;
  String message;
  String timeStamp;
  String messageType;
  bool isRead;

  NotificationModel(
      this.title, this.message, this.timeStamp, this.messageType, this.isRead);

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(json["title"], json["message"], json["timeStamp"],
        json["messageType"], json["isRead"]);
  }
  Map<String, Object> toJson() {
    return {
      'title': title,
      'message': message,
      'timeStamp': timeStamp,
      'messageType': messageType,
      'isRead': isRead
    };
  }
}
