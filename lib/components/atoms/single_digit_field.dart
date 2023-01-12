import 'package:flutter/material.dart';

class SingleDigitField extends StatelessWidget {
  double widthPercentage;
  double fontSize;
  double borderRadius;
  TextEditingController controller;
  Function onChanged;
  FocusNode focusNode;
  SingleDigitField(
      {Key key,
      this.borderRadius = 5,
      this.fontSize = 16,
      this.widthPercentage = 0.10,
      this.controller,
      this.onChanged,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.12,
      child: TextField(
        onChanged: onChanged,
        focusNode: focusNode,
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterText: "",
            fillColor: Colors.grey[300],
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
