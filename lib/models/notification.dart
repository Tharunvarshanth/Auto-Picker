class Notification {
  String notificationId;
  String title;
  String subtitle;
  String message;
  String timeStamp;
  String messageType;

  Notification(this.notificationId, this.title, this.subtitle, this.message,
      this.timeStamp, this.messageType);

  Map<String, Object> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'subtitle': subtitle,
      'message': message,
      'timeStamp': timeStamp,
      'messageType': messageType
    };
  }
}
