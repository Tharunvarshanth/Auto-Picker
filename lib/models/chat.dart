import 'package:auto_picker/models/chat_data.dart';

class Chat {
  String user1;
  String user2;
  List<ChatData> chatData;

  Chat(this.user1, this.user2, this.chatData);

  Map<String, Object> toJson() {
    return {'user1': user1, 'user2': user2, 'chatData': chatData};
  }
}
