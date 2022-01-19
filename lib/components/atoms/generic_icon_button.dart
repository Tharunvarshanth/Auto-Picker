import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GenericIconButton(
        onPressed: () {},
        text: ('this is text'),
      )),
    );
  }
}

class GenericIconButton extends StatelessWidget {
  Color backgroundColor;
  Color textColor;
  void Function() onPressed;
  String text;
  Color borderColor;
  Color shadowColor;
  double borderRadius;
  EdgeInsets padding;
  Icon iconLeft;
  GenericIconButton(
      {Key key,
      this.backgroundColor,
      this.textColor,
      this.onPressed,
      this.borderColor,
      this.shadowColor,
      this.borderRadius,
      this.padding,
      this.iconLeft,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: iconLeft != null ? iconLeft : Text(text),
      label: iconLeft != null ? Text(text) : iconLeft,
      style: ElevatedButton.styleFrom(
          shadowColor: shadowColor ?? Colors.grey,
          elevation: 15,
          primary: backgroundColor ?? Colors.white,
          onPrimary: textColor ?? Colors.blue,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5),
              side: BorderSide(
                  color: borderColor ?? Colors.grey,
                  width: 1,
                  style: BorderStyle.solid))),
    );
  }
}
