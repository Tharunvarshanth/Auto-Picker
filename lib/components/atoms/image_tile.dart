import 'package:flutter/material.dart';

class ImageTile extends StatefulWidget {
  int index;
  String imgUrl;
  String text;
  double textSize;
  Color textColor;
  double width;
  double margin;
  double borderRadius;
  double textPadding;
  String subText;
  Color subTextColor;
  double subtextSize;
  void Function() onPressed;

  ImageTile(
      {Key key,
      this.index,
      this.imgUrl,
      this.subTextColor = Colors.black,
      this.subtextSize = 16,
      this.text,
      this.textSize = 20,
      this.margin = 5,
      this.subText = 'no sub',
      this.textPadding = 5,
      this.borderRadius = 20,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: widget.margin),
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: widget.index % 2 == 0 ? Colors.blue : Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                        color: widget.index % 2 == 0
                            ? Colors.blue[200]
                            : Colors.deepPurple[200],
                        width: 3),
                    gradient: RadialGradient(
                        colors: widget.index % 2 == 0
                            ? [Colors.blue[100], Colors.blue[200]]
                            : [
                                Colors.deepPurple[100],
                                Colors.deepPurple[200]
                              ])),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(widget.textPadding),
                        child: Text(
                          widget.text,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.textSize,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(widget.textPadding),
                        child: Text(
                          widget.subText,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.subTextColor,
                            fontSize: widget.subtextSize,
                          ),
                        ),
                      ),
                    ])),
          ],
        ),
      ),
    );
  }
}
