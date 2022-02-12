class NotificationData {
  String title;
  String byOwner;
  DateTime dateTime;
  String description;
  String notificationImgUrl;
  bool read;
  NotificationData(
      {this.byOwner,
      this.dateTime,
      this.description,
      this.notificationImgUrl,
      this.read,
      this.title});
}
