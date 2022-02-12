class ChatData {
  DateTime dateTime;
  String avatarUrl;
  String userName;
  String message;
  String messageImageUrl;
  bool fromUser;

  ChatData(
      {this.dateTime,
      this.avatarUrl = '',
      this.userName = '',
      this.message = '',
      this.fromUser = true,
      this.messageImageUrl = ''}) {
    this.dateTime = dateTime;
  }
}
