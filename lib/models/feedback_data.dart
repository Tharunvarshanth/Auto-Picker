class FeedBackData {
  String userName;
  DateTime dateTime;
  String feedbackMessage;
  String profilePicUrl;

  FeedBackData(
      {this.userName = 'no user name',
      this.feedbackMessage = 'no message',
      this.profilePicUrl = ''}) {
    this.dateTime = DateTime.now();
  }
}
