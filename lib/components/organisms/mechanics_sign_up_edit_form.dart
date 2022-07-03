import 'dart:async';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/map_edit_page.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MechanicsSignUpEditForm extends StatefulWidget {
  UserModel userModel;
  Mechanic mechanic;
  MechanicsSignUpEditForm({this.userModel, this.mechanic});
  @override
  _MechanicsSignUpEditFormState createState() =>
      _MechanicsSignUpEditFormState();
}

class _MechanicsSignUpEditFormState extends State<MechanicsSignUpEditForm> {
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final timePickerToController = TextEditingController();
  final timePickerFromController = TextEditingController();
  var userController = UserController();
  var mechanicController = MechanicController();
  String _valueChangedStart = '';
  String _valueToValidateStart = '';
  String _valueSavedStart = '';

  String _valueChangedFinish = '';
  String _valueToValidateFinish = '';
  String _valueSavedFinish = '';
  bool isMapclicked = false;
  City city;
  String specialist;
  List<City> dropDownCityList = [];

  void initState() {
    super.initState();
    Intl.defaultLocale = 'en_LK';

    addressController.text = widget.mechanic.workingAddress;
    timePickerToController.text = (widget.mechanic.workingTime_To);
    timePickerFromController.text = (widget.mechanic.workingTime_From);
    setState(() {
      _valueChangedStart = widget.mechanic.workingTime_To;
      _valueToValidateStart = widget.mechanic.workingTime_To;
      _valueChangedFinish = widget.mechanic.workingTime_From;
      _valueToValidateFinish = widget.mechanic.workingTime_From;
      city.city = widget.mechanic.workingCity;
      specialist = widget.mechanic.specialist;
    });
  }

  void handleCity(cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleMechanicsSpecialist(skill) {
    setState(() {
      specialist = skill;
    });
  }

  void handleNext() {
    print("TO handleNext ${_valueChangedStart}");
    widget.mechanic.specialist = specialist;
    widget.mechanic.workingCity = city.city;
    widget.mechanic.workingAddress = addressController.text;
    widget.mechanic.workingTime_To = _valueChangedStart;
    widget.mechanic.workingTime_From = _valueChangedFinish;

    Future.wait([
      userController.updateUser(widget.userModel),
      mechanicController.updateMechanic(widget.mechanic)
    ]).then((List<bool> res) {
      print(res[0]);
      if (res[0] && res[1]) {
        //popup
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/done.svg',
                  titleText: 'Done ok',
                  bodyText: "",
                  primaryButtonText: 'Ok',
                  onPressedPrimary: () =>
                      navigate(context, RouteGenerator.homePage),
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/x-circle.svg',
                  titleText: 'Failure',
                  bodyText: "",
                  primaryButtonText: 'Ok',
                  onPressedPrimary: () =>
                      navigate(context, RouteGenerator.homePage),
                ));
      }
    });
  }

  void fillRequiredFields() {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: 'Fill All Required Fields',
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
              text: isMapclicked
                  ? 'Location updated'
                  : 'Update your working Location',
              onPressed: () {
                widget.mechanic.specialist = specialist;
                widget.mechanic.workingCity = city.city;
                widget.mechanic.workingAddress = addressController.text;
                widget.mechanic.workingTime_To = _valueChangedStart;
                widget.mechanic.workingTime_From = _valueChangedFinish;
                setState(() {
                  isMapclicked = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapLatLonEditPage(
                          userModel: widget.userModel,
                          mechanic: widget.mechanic)),
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
                if (addressController.text.isEmpty ||
                    timePickerFromController.text.isEmpty ||
                    specialist.toString().isEmpty ||
                    city.toString().isEmpty) {
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
