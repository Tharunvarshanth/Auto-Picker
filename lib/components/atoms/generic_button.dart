import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  Color backgroundColor;
  Color textColor;
  void Function() onPressed;
  String text;
  Color borderColor;
  Color shadowColor;
  double borderRadius;
  double paddingVertical;
  double paddingHorizontal;
  double elevation;
  double textsize;
  bool isBold;
  GenericButton(
      {Key key,
      this.backgroundColor,
      this.textColor,
      this.onPressed,
      this.borderColor,
      this.shadowColor,
      this.borderRadius,
      this.elevation,
      this.paddingHorizontal,
      this.paddingVertical,
      this.textsize = 16,
      this.isBold = false,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: textsize,
            color: textColor ?? AppColors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
      style: ElevatedButton.styleFrom(
          shadowColor: shadowColor ?? AppColors.grey,
          elevation: (elevation ?? 15),
          primary: backgroundColor ?? AppColors.blue,
          onPrimary: textColor ?? AppColors.white,
          padding: EdgeInsets.symmetric(
              vertical: (paddingVertical ?? 30),
              horizontal: (paddingHorizontal ?? 30)),
          shape: borderColor != null
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  side: BorderSide(
                      color: borderColor ?? AppColors.grey,
                      width: 1,
                      style: BorderStyle.solid))
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                )),
    );
  }
}
