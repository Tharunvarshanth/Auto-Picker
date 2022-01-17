import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class GenericText extends StatelessWidget {
  String text;
  Color color;
  double textSize;
  bool isBold;
  GenericText(
      {Key key, this.text, this.color, this.textSize, this.isBold = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? AppColors.black,
          fontSize: textSize ?? 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
