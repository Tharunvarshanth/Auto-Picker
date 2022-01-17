import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

import 'generic_text.dart';

class GenericInputOptionSelect extends StatelessWidget {
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
  double width;
  String value;
  List<String> itemList;
  void Function(String text) onValueChange;
  GenericInputOptionSelect(
      {Key key,
      this.counterText = '',
      this.prefixText = '',
      this.helperText = '',
      this.hintText = '',
      this.labelText = '',
      this.fieldIcon,
      this.prefixIcon,
      this.inputType = TextInputType.text,
      this.borderColor = Colors.grey,
      this.focusBorderColor = Colors.blue,
      this.onValueChange,
      this.itemList,
      this.width,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        GenericText(
          text: labelText,
          isBold: true,
        ),
        const SizedBox(
          height: 5,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.ash, width: 1),
              borderRadius: BorderRadius.circular(3),
              boxShadow: <BoxShadow>[]),
          child: SizedBox(
            width: width,
            child: DropdownButton<String>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(30),
              value: value,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: AppColors.blue),
              underline: Container(),
              onChanged: (String newValue) {
                onValueChange(newValue);
              },
              items: itemList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
