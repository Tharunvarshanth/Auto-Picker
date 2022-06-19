import 'dart:async';
import 'dart:convert';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MechanicsSignUpForm extends StatefulWidget {
  final Map<String, dynamic> params;
  const MechanicsSignUpForm({Map<String, dynamic> this.params});
  @override
  _MechanicsSignUpFormState createState() => _MechanicsSignUpFormState();
}

class _MechanicsSignUpFormState extends State<MechanicsSignUpForm> {
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final timePickerToController = TextEditingController();
  final timePickerFromController = TextEditingController();

  String _valueChangedStart = '';
  String _valueToValidateStart = '';
  String _valueSavedStart = '';

  String _valueChangedFinish = '';
  String _valueToValidateFinish = '';
  String _valueSavedFinish = '';

  City city;
  String specialist;
  List<City> dropDownCityList = [];

  void initState() {
    super.initState();
    setData();
    Intl.defaultLocale = 'en_LK';
    if (widget.params["location-lat"] != null) {
      setState(() {
        specialist = widget.params['specialist'];
        _valueChangedStart = widget.params['workingTime_To'];
        _valueChangedFinish = widget.params['workingTime_From'];
        city = widget.params['workingCity'];
      });
      addressController.text = widget.params['address'];
      timePickerToController.text = widget.params['workingTime_To'];
      timePickerFromController.text = widget.params['workingTime_From'];
    }
  }

  void setData() async {
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
    });
    print(dropDownCityList[0].city);
  }

  void handleCity(City cityName) {
    setState(() {
      city = cityName;
    });
    print(city.city);
  }

  void handleMechanicsSpecialist(skill) {
    setState(() {
      specialist = skill;
    });
  }

  void handleNext() {
    widget.params['specialist'] = specialist;
    widget.params['workingCity'] = city;
    widget.params['workingAddress'] = addressController.text;
    widget.params['workingTime_To'] = _valueChangedStart;
    widget.params['workingTime_From'] = _valueChangedFinish;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpSignUpPage(params: widget.params),
      ),
    );
  }

  void fillRequiredFields() {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: 'Fill Required Fields',
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> cityList = [
      Users.Admin,
      Users.Mechanic,
      Users.NormalUser,
      Users.Seller
    ];
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'Specialist *',
              value: specialist,
              itemList: MechanicSpecialistSkills,
              onValueChange: (text) => handleMechanicsSpecialist(text),
            ),
            SizedBox(height: size.height * 0.015),
            GenericInputOptionCitysSelect(
              width: size.width,
              labelText: 'Working City *',
              value: city,
              itemList: dropDownCityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: addressController,
              labelText: 'Address *',
              hintText: "No 16 , Galle Road",
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 150,
                  child: GenericTimePicker(
                      controller: timePickerToController,
                      labelText: 'Start *',
                      onChanged: (value) => {
                            print("time ${value}"),
                            setState(() {
                              _valueChangedStart = value;
                            })
                          },
                      onSaved: (value) => {
                            setState(() {
                              _valueSavedStart = value;
                            })
                          }),
                ),
                Container(
                  width: 150,
                  child: GenericTimePicker(
                      controller: timePickerFromController,
                      labelText: 'Finish *',
                      onChanged: (value) => {
                            print("time ${value}"),
                            setState(() {
                              _valueChangedFinish = value;
                            })
                          },
                      onSaved: (value) => {
                            print("time onsave ${value}}"),
                            setState(() {
                              _valueSavedFinish = value;
                            })
                          }),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.015),
            Container(
                child: GenericTextButton(
              text: widget.params["location-lat"] != null
                  ? 'location picked'
                  : 'Pick your working Location',
              onPressed: () {
                widget.params['specialist'] = specialist;
                widget.params['workingCity'] = city;
                widget.params['address'] = addressController.text;
                widget.params['workingTime_To'] = _valueChangedStart;
                widget.params['workingTime_From'] = _valueChangedFinish;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapLatLonPage(params: widget.params),
                  ),
                );
              },
            )),
            SizedBox(height: size.height * 0.015),
            GenericButton(
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Next',
              onPressed: () {
                if (specialist.toString().isEmpty ||
                    city.toString().isEmpty ||
                    addressController.text.isEmpty ||
                    _valueChangedFinish.toString().isEmpty ||
                    _valueChangedStart.toString().isEmpty) {
                  fillRequiredFields();
                  return;
                }
                handleNext();
              },
              isBold: true,
            )
          ],
        ));
  }
}
