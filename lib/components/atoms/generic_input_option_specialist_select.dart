import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'generic_text.dart';

class GenericInputOptionSpecialistSelect extends StatelessWidget {
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
  bool enable = true;
  void Function() onTap = () => {};
  void Function(String specilaist) onValueChange;
  GenericInputOptionSpecialistSelect(
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
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myKey = GlobalKey<DropdownSearchState<String>>();
    Size size = MediaQuery.of(context).size;
    var items = itemList.map((value) {
      return DropdownMenuItem<String>(
        enabled: enable ?? true,
        value: value,
        child: Text(value),
      );
    }).toList();

    if (items.isEmpty) {
      items = [
        const DropdownMenuItem(
          child: Text(''),
          value: null,
        )
      ];
    }
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
              boxShadow: const <BoxShadow>[]),
          child: SizedBox(
              width: width,
              child: DropdownSearch<String>(
                key: myKey,
                showSearchBox: true,
                items: itemList,
                dropdownSearchDecoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(8, 10, 0, 2),
                  labelStyle: const TextStyle(color: AppColors.black),
                  labelText: value,
                  hintText: "Specialist",
                ),
                onChanged: (String newValue) {
                  onValueChange(newValue);
                },
                popupItemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 1),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 16,
                        height: 2,
                        color: Colors.black,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              )

              /* DropdownButton<City>(
              menuMaxHeight: 500,
              onTap: () => onTap,
              isExpanded: true,

              //borderRadius: BorderRadius.circular(30),
              value: value,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: AppColors.blue),
              underline: Container(),
              onChanged: (City newValue) {
                onValueChange(newValue);
              },
              items: items,

            ),
            */
              ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
