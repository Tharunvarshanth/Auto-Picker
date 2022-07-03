import 'dart:async';
import 'dart:convert';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
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

class SellerSignUpForm extends StatefulWidget {
  final Map<String, dynamic> params;
  const SellerSignUpForm({Map<String, dynamic> this.params});
  @override
  _SellerSignUpFormState createState() => _SellerSignUpFormState();
}

class _SellerSignUpFormState extends State<SellerSignUpForm> {
  final shopNameController = TextEditingController();
  final shopNumberController = TextEditingController();
  final shopAddressController = TextEditingController();

  City city;
  List<City> dropDownCityList = [];

  void initState() {
    setData();
  }

  void setData() async {
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
    });
  }

  void handleCity(cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleNext() {
    widget.params['shopName'] = shopNameController.text;
    widget.params['shopAddress'] = shopAddressController.text;
    widget.params['shopPhoneNumber'] = shopNumberController.text;
    widget.params['shopcity'] = city.city;

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
              titleText: 'Fill All Required Fields',
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  @override
  void dispose() {
    shopAddressController.dispose();
    shopNumberController.dispose();
    shopNameController.dispose();
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
            TextFormField(
              controller: shopNameController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Shop Name',
                  hintText: "TM Motors",
                  labelStyle: TextStyle(fontSize: 15)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your shop name';
                }
                return null;
              },
            ),
            SizedBox(height: size.height * 0.015),
            TextFormField(
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: const InputDecoration(
                  prefixText: '+94',
                  prefixStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your Phone number here',
                  labelStyle: TextStyle(
                    fontSize: 15,
                  )),
              controller: shopNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Phone number';
                }
                return null;
              },
            ),
            SizedBox(height: size.height * 0.015),
            GenericInputOptionCitysSelect(
              width: size.width,
              labelText: 'City',
              value: city,
              itemList: dropDownCityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.015),
            TextFormField(
              controller: shopAddressController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Shop Address',
                  hintText: 'NO 16, Galle Road',
                  labelStyle: TextStyle(fontSize: 15)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your shop address';
                }
                return null;
              },
            ),
            SizedBox(height: size.height * 0.015),
            GenericButton(
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Next',
              onPressed: () {
                if (shopNameController.text.isEmpty ||
                    shopNumberController.text.isEmpty ||
                    shopAddressController.text.isEmpty ||
                    city?.city == '' ||
                    city == null) {
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
