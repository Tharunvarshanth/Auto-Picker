import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:flutter/material.dart';

class GenericTextField extends StatelessWidget {
  String counterText;
  String prefixText;
  String helperText;
  String hintText;
  String labelText;
  Color borderColor;
  Color focusBorderColor;
  Icon fieldIcon;
  TextInputType inputType;
  Icon prefixIcon;
  TextEditingController controller;
  GenericTextField(
      {Key key,
      this.controller,
      this.counterText = '',
      this.prefixText = '',
      this.helperText = '',
      this.hintText = '',
      this.labelText = '',
      this.fieldIcon,
      this.prefixIcon,
      this.inputType = TextInputType.text,
      this.borderColor = Colors.grey,
      this.focusBorderColor = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericText(
          text: labelText,
          isBold: true,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
            keyboardType: inputType,
            controller: controller,
            decoration: InputDecoration(
              icon: fieldIcon,
              prefixIcon: prefixIcon,
              counterText: counterText,
              prefixText: prefixText,
              helperText: helperText,
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: focusBorderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.0),
              ),
            ))
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
