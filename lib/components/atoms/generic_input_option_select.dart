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
  String dropDownValue;
  List<String> itemList;
  bool enable = true;
  void Function() onTap = () => {};
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
      this.enable,
      this.onTap,
      this.dropDownValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        GenericText(
          text: labelText,
          textSize: 14,
          isBold: true,
        ),
        const SizedBox(
          height: 5,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.ash, width: 1),
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[]),
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
            width: width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: DropdownButton<String>(
                onTap: () => onTap,
                isExpanded: true,
                menuMaxHeight: 500,
                borderRadius: BorderRadius.circular(5),
                value: dropDownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: AppColors.black),
                underline: Container(),
                onChanged: (String newValue) {
                  onValueChange(newValue);
                },
                items: itemList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    enabled: enable ?? true,
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
