import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'generic_text.dart';

class GenericInputOptionCitysSelect extends StatelessWidget {
  String counterText;
  String prefixText;
  String helperText;
  String hintText;
  String labelText;
  Color borderColor;
  Color focusBorderColor;
  Icon fieldIcon;
  TextInputType inputType;
  IconData prefixIcon;
  double width;
  City value;
  List<City> itemList;
  bool enable = true;
  void Function() onTap = () => {};
  void Function(City city) onValueChange;
  GenericInputOptionCitysSelect({
    Key key,
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
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myKey = GlobalKey<DropdownSearchState<City>>();
    Size size = MediaQuery.of(context).size;
    var items = itemList.map((value) {
      return DropdownMenuItem<City>(
        enabled: enable ?? true,
        value: value,
        child: Text(value?.city),
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
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const <BoxShadow>[]),
          child: SizedBox(
              width: width,
              child: DropdownSearch<City>(
                key: myKey,
                showSearchBox: true,
                items: itemList,
                dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  focusColor: Colors.blue[100],
                  prefixText: prefixText,
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: Colors.blue[500],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fillColor: Colors.blue[100],
                  hintText: "Choose city",
                  hintStyle: TextStyle(
                    color: Colors.blue[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  labelText: value?.city,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onChanged: (City newValue) {
                  onValueChange(newValue);
                },
                popupItemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 1),
                    child: Text(
                      item.city,
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
              )),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
