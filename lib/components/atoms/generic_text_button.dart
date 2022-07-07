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
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      child: Text(text),
    );
  }
}
