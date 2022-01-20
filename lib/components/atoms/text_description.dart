import 'package:flutter/material.dart';

class TextDescription extends StatelessWidget {
  String title;
  String description;
  double titleTextSize;
  double descriptionTextSize;
  double iconSize;
  Color titleColor;
  Color descriptionColor;
  Color iconColor;
  IconData icon;
  Color borderColor;
  double padding;
  TextDescription(
      {Key key,
      this.description = 'No Description',
      this.descriptionColor = Colors.black45,
      this.descriptionTextSize = 16,
      this.iconColor = Colors.black,
      this.iconSize,
      this.title = 'No Title',
      this.titleColor = Colors.black,
      this.titleTextSize = 20,
      this.icon = Icons.arrow_right,
      this.padding = 10,
      this.borderColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      //decoration: BoxDecoration(border: Border.all(color: borderColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: titleTextSize, color: titleColor),
                  textAlign: TextAlign.start,
                ),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: descriptionTextSize, color: descriptionColor),
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
