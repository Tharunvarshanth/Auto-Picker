import 'package:flutter/material.dart';

class SingleDigitField extends StatelessWidget {
  double widthPercentage;
  double fontSize;
  double borderRadius;
  TextEditingController controller;
  SingleDigitField(
      {Key key,
      this.borderRadius = 20,
      this.fontSize = 16,
      this.widthPercentage = 0.10,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.12,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
            counterText: '',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
