import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class GenericTimePicker extends StatelessWidget {
  String labelText;
  Color borderColor;
  Color focusBorderColor;
  Icon fieldIcon;
  TextInputType inputType;
  Icon prefixIcon;
  TextEditingController controller;
  void Function(String) onChanged;
  void Function(String) onSaved;
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';

  GenericTimePicker({
    Key key,
    this.controller,
    this.labelText = '',
    this.fieldIcon,
    this.prefixIcon,
    this.inputType = TextInputType.text,
    this.borderColor = Colors.grey,
    this.onChanged,
    this.onSaved,
    this.focusBorderColor = Colors.blue,
  }) : super(key: key);

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
        DateTimePicker(
          type: DateTimePickerType.time,
          //timePickerEntryModeInput: true,
          controller: controller,
          icon: Icon(Icons.access_time),
          timeLabelText: "Time",
          use24HourFormat: true,
          locale: Locale('en', 'LK'),
          onChanged: (val) => onChanged(val ?? ''),
          /*validator: (val) {
               setState(() => _valueToValidate4 = val ?? '');
              return null;
            },*/
          onSaved: (val) => onSaved(val ?? ''),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
