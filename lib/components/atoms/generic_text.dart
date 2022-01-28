import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class GenericText extends StatelessWidget {
  String text;
  Color color;
  double textSize;
  bool isBold;
  int maxLines;
  TextAlign textAlign;
  GenericText(
      {Key key,
      this.text,
      this.color,
      this.textSize,
      this.isBold = false,
      this.maxLines,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines ?? 1,
      style: TextStyle(
          color: color ?? AppColors.black,
          fontSize: textSize ?? 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
