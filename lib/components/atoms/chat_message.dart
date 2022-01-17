import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
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
  ChatMessage(
      {Key key,
      this.backgroundColor = Colors.blue,
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$messageHint',
            style: TextStyle(color: hintTextColor),
            textAlign: TextAlign.start,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            padding: EdgeInsets.symmetric(
                vertical: messagePaddingVertical,
                horizontal: messagePaddingHorizontal),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child: Text('$messageBody',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: messageTextColor, fontSize: messageTextSize)),
          ),
          Container(
            child: Text(
              (dateTime ?? DateTime.now()).toString(),
              textAlign: TextAlign.end,
              style:
                  TextStyle(fontSize: dateTimeTextSize, color: dateTimeColor),
            ),
          )
        ],
      ),
    );
  }
}
