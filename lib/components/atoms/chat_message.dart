import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  String messageBody;
  String messageHint;
  DateTime dateTime;
  Color backgroundColor;
  Color messageTextColor;
  Color hintTextColor;
  Color dateTimeColor;
  double messagePaddingHorizontal;
  double messagePaddingVertical;
  double messageTextSize;
  double dateTimeTextSize;
  String picUrl;
  ChatMessage(
      {Key key,
      this.backgroundColor = Colors.blue,
      this.picUrl = '',
      this.dateTime,
      this.dateTimeColor = Colors.black,
      this.dateTimeTextSize = 12,
      this.hintTextColor = Colors.purple,
      this.messageBody =
          'No message to dfsj skfdsd dksf skf sdkfl kslkf skslfksdfklsk s fkslpdfkldview',
      this.messageHint = 'No hint to view',
      this.messagePaddingHorizontal = 20,
      this.messageTextColor = Colors.white,
      this.messageTextSize = 20,
      this.messagePaddingVertical = 15})
      : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.messageHint}',
            style: TextStyle(color: widget.hintTextColor),
            textAlign: TextAlign.start,
          ),
          widget.picUrl != ''
              ? Image.network(
                  widget.picUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                        'https://1080motion.com/wp-content/uploads/2018/06/NoImageFound.jpg.png');
                  },
                  fit: BoxFit.contain,
                )
              : SizedBox(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            padding: EdgeInsets.symmetric(
                vertical: widget.messagePaddingVertical,
                horizontal: widget.messagePaddingHorizontal),
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child: Text('${widget.messageBody}',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: widget.messageTextColor,
                    fontSize: widget.messageTextSize)),
          ),
          Container(
            child: Text(
              (widget.dateTime ?? DateTime.now()).toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: widget.dateTimeTextSize,
                  color: widget.dateTimeColor),
            ),
          )
        ],
      ),
    );
  }
}
