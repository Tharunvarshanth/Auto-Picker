class ChatData {
  String timeStamp;
  String message;
  String senderId;

  ChatData(this.timeStamp, this.message, this.senderId);

  Map<String, Object> toJson() {
    return {'timeStamp': timeStamp, 'message': message, 'senderId': senderId};
  }
}
