class FeedBackData {
  String userName;
  String dateTime;
  String feedbackMessage;

  FeedBackData(
    this.userName,
    this.dateTime,
    this.feedbackMessage,
  );

  factory FeedBackData.fromJson(dynamic json) {
    return FeedBackData(
        json["userName"], json["dateTime"], json["feedbackMessage"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'dateTime': dateTime,
      'feedbackMessage': feedbackMessage
    };
  }
}
