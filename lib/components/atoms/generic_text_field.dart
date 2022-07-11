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
  IconData prefixIcon;
  TextEditingController controller;
  bool autofocus;
  int maxLength;
  TextInputType keyboardType;
  GenericTextField(
      {Key key,
      this.controller,
      this.counterText = '',
      this.prefixText = '',
      this.helperText = '',
      this.hintText = '',
      this.labelText = '',
      this.fieldIcon,
      this.prefixIcon = Icons.text_fields,
      this.borderColor = Colors.grey,
      this.focusBorderColor = Colors.blue,
      this.autofocus = false,
      this.maxLength = null,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            autofocus: autofocus,
            keyboardType: keyboardType,
            controller: controller,
            maxLength: maxLength,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
              focusColor: Colors.blue[100],
              prefixText: prefixText,
              counterText: "",
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.blue[500],
              ),
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              fillColor: Colors.blue[100],
              hintText: "",
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              labelText: labelText != "" ? labelText : "",
              labelStyle: TextStyle(
                color: Colors.blue[500],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ))
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
