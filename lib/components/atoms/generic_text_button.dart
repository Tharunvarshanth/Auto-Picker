import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class GenericTextButton extends StatelessWidget {
  String text;
  Color color;
  double textSize;
  bool isBold;
  void Function() onPressed;
  GenericTextButton(
      {Key key,
      this.text,
      this.color,
      this.textSize,
      this.isBold = false,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: onPressed,
      style: TextButton.styleFrom(
          textStyle: TextStyle(
              color: color ?? AppColors.grey,
              fontSize: textSize ?? 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
