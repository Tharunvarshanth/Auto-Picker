import 'package:flutter/material.dart';

class ImageTile extends StatefulWidget {
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
      this.imgUrl,
      this.subTextColor = Colors.black,
      this.subtextSize = 16,
      this.text,
      this.textSize = 20,
      this.margin = 20,
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
            /*if (widget.imgUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Image.network(
                  widget.imgUrl ?? '',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Placeholder();
                  },
                ),
              ),*/
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(widget.textPadding),
                    child: Text(
                      widget.text,
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.subTextColor,
                        fontSize: widget.subtextSize,
                      ),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
