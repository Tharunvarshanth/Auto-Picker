import 'package:auto_picker/components/atoms/chat_message.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/models/user_chat_data.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _chatController = TextEditingController();
  int letterCount = 0;
  bool _floatVisible = false;
  List<ChatData> chatList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    letterCount = _chatController.text.length;
    _chatController.addListener(() {
      setState(() {
        letterCount = _chatController.text.length;
      });
    });

    _scrollController.addListener(() async {
      if (_scrollController.offset >=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        //fetch new data
        // if (no data!!) {
        //   return;
        // }
        print('reloading');
        setState(() {
          //put data
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat',
          style: TextStyle(fontSize: 24),
        ),
        leading: Icon(Icons.arrow_back),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_outlined),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: chatList.length == 0
                  ? [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'No messages. wait or start messaging!!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                      Image.network(
                          'https://startmessaging.in/images/StartMessagingLogo.png')
                    ]
                  : chatList.map<Widget>((e) {
                      if (e.fromUser) {
                        return UserChatTile(e.dateTime,
                            avatarUrl: e.avatarUrl,
                            message: e.message,
                            messageImgUrl: e.messageImageUrl,
                            userName: e.userName);
                      }
                      return ReceiverChatTile(e.dateTime,
                          avatarUrl: e.avatarUrl,
                          message: e.message,
                          messageImgUrl: e.messageImageUrl,
                          userName: e.userName);
                    }).toList(),
            ),
          )),
          Card(
              elevation: 8,
              borderOnForeground: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GenericTextField(
                      controller: _chatController,
                      prefixIcon: Icon(Icons.message),
                      hintText: 'Type your message here...',
                      prefixText: '',
                      labelText: '',
                      counterText: letterCount.toString(),
                      helperText: '',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt_outlined)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.picture_in_picture)),
                      Expanded(
                          child: IconButton(
                              alignment: Alignment.topRight,
                              onPressed: () {},
                              icon: Icon(Icons.message_outlined))),
                    ],
                  )
                ],
              ))
        ],
        mainAxisSize: MainAxisSize.max,
      ),
    ));
  }
}

Widget UserChatTile(DateTime dateTime,
    {String avatarUrl = '',
    String userName = 'User name here',
    String message = 'Message here',
    String messageImgUrl = ''}) {
  return Container(
    child: Row(
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(avatarUrl),
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Breezeicons-actions-22-im-user.svg/1200px-Breezeicons-actions-22-im-user.svg.png'),
        ),
        Expanded(
            child: ChatMessage(
          dateTime: dateTime,
          messageHint: userName,
          messageBody: message,
          picUrl: messageImgUrl,
        ))
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
  );
}

Widget ReceiverChatTile(DateTime dateTime,
    {String avatarUrl = '',
    String userName = '',
    String message = '',
    String messageImgUrl = ''}) {
  return Container(
    child: Row(
      children: [
        Expanded(
            child: ChatMessage(
          dateTime: dateTime,
          messageBody: message,
          messageHint: userName,
          backgroundColor: Colors.grey[200],
          messageTextColor: Colors.black,
          picUrl: messageImgUrl,
        )),
        CircleAvatar(
          foregroundImage: NetworkImage(avatarUrl),
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Breezeicons-actions-22-im-user.svg/1200px-Breezeicons-actions-22-im-user.svg.png'),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
  );
}
