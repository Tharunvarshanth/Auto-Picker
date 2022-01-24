import 'dart:async';
import 'dart:convert';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
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
  final specialistController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final timePickerToController = TextEditingController();
  final timePickerFromController = TextEditingController();

  String _valueChangedTo = '';
  String _valueToValidateTo = '';
  String _valueSavedTo = '';

  String _valueChangedFrom = '';
  String _valueToValidateFrom = '';
  String _valueSavedFrom = '';

  String city;

  void initState() {
    super.initState();
    Intl.defaultLocale = 'en_LK';
    if (widget.params["location-lat"] != null) {
      specialistController.text = widget.params['specialist'];
      setState(() {
        city = widget.params['workingCity'];
      });
      addressController.text = widget.params['address'];
      timePickerToController.text = widget.params['workingTime_To'];
      timePickerFromController.text = widget.params['workingTime_From'];
    }
  }

  void handleCity(cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleNext() {
    widget.params['specialist'] = specialistController.text;
    widget.params['workingCity'] = city;
    widget.params['workingAddress'] = addressController.text;
    widget.params['workingTime_To'] = _valueChangedTo;
    widget.params['workingTime_From'] = _valueChangedFrom;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpSignUpPage(params: widget.params),
      ),
    );
  }

  @override
  void dispose() {
    specialistController.dispose();
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
            GenericTextField(
              controller: specialistController,
              labelText: 'Specialist',
              hintText: "Electrician",
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'Working City',
              value: city,
              itemList: cityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: addressController,
              labelText: 'Address',
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
                      labelText: 'To',
                      onChanged: (value) => {
                            print("time ${value}"),
                            setState(() {
                              _valueChangedTo = value;
                            })
                          },
                      onSaved: (value) => {
                            setState(() {
                              _valueSavedTo = value;
                            })
                          }),
                ),
                Container(
                  width: 150,
                  child: GenericTimePicker(
                      controller: timePickerFromController,
                      labelText: 'From',
                      onChanged: (value) => {
                            print("time ${value}"),
                            setState(() {
                              _valueChangedFrom = value;
                            })
                          },
                      onSaved: (value) => {
                            print("time onsave ${value}}"),
                            setState(() {
                              _valueSavedTo = value;
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
                widget.params['specialist'] = specialistController.text;
                widget.params['workingCity'] = city;
                widget.params['address'] = addressController.text;
                widget.params['workingTime_To'] = _valueChangedTo;
                widget.params['workingTime_From'] = _valueChangedFrom;

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
                //validations ok
                handleNext();
              },
              isBold: true,
            )
          ],
        ));
  }
}
