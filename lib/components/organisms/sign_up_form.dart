import 'dart:async';
import 'dart:io';
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
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var userController = UserController();
  City city;
  String role;
  bool isvalidUser = false;
  List<City> dropDownCityList = [];
  String formattedNumber;
  bool isAcceptsTermsAndConditons = false;

  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
    });
  }

  void handleCity(City cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleRole(roleName) {
    setState(() {
      role = roleName;
    });
  }

  Future<bool> isNumberAlreadyHaveAccount(String numberText) async {
    var number = numberText;
    var res = await userController.isNumberAlreadyHaveAccount(number);
    if (res) {
      //if user has account already  error pop up go login page
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Login Failure',
                bodyText: "This user already have an account",
                primaryButtonText: 'Login',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.loginPage),
                secondaryButtonText: 'Ok',
                onPressedSecondary: () => Navigator.pop(context, 'Cancel'),
              ));
      isvalidUser = false;
      // navigate(context, RouteGenerator.loginPage);
    } else {
      // if user doesn't have account error pop up go login page
      isvalidUser = true;
      handleNext();
    }
  }

  void handleNext() {
    print(city?.city);
    if (isvalidUser) {
      var param = {
        'name': nameController.text,
        'address': addressController.text,
        'phoneNumber': formattedNumber,
        'city': city.city,
        'role': role
      };
      switch (role) {
        case Users.Mechanic:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MechanicsSignUpPage(params: param),
            ),
          );
          break;
        case Users.Seller:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SellerSignUpPage(params: param),
            ),
          );
          break;
        case Users.NormalUser:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpSignUpPage(params: param),
            ),
          );
          break;
        default:
          break;
      }
    }
  }

  void fillRequiredFields(text) {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: text,
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  String formattedPhone(String text) {
    String phonenumber = text.trim();
    if (phonenumber.length == 10) {
      return "+94" + phonenumber.substring(1);
    }
    if (phonenumber.length == 9) {
      phonenumber = phonenumber;
      return "+94" + phonenumber;
    }
    return null;
  }

  void showTermsAndConditions() {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
            titleText: 'Terms and Conditions',
            bodyText: '''
Last updated: 10/07/2022

Please read these Terms and Conditions carefully before using the Auto Picker mobile
application operated by us Your access to and use of the Service is conditioned on your acceptance of and compliance with
these Terms. These Terms apply to all visitors, users and others who access or use the Service.
By accessing or using the Service you agree to be bound by these Terms. If you disagree
with any part of the terms, then you may not access the Service.

Purchases
If you wish to purchase any product or service made available through the Service ("Purchase"),
you may be asked to supply certain information relevant to your Purchase including.


Content
Our Service allows you to post, link, store, share and otherwise make available certain information,
text, graphics, videos, or other material ("Content").

Contact Us
If you have any questions about these Terms, please contact us
''',
            primaryButtonText: 'Close',
            onPressedPrimary: () => Navigator.pop(context, 'Cancel')));
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> roleList = [Users.NormalUser, Users.Mechanic, Users.Seller];
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            GenericTextField(
              controller: nameController,
              labelText: "Name",
              prefixIcon: Icons.supervised_user_circle,
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: addressController,
              labelText: "Address",
              prefixIcon: Icons.streetview,
            ),
            SizedBox(height: size.height * 0.020),
            GenericInputOptionCitysSelect(
              width: size.width,
              labelText: ' City',
              value: city,
              itemList: dropDownCityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              keyboardType: TextInputType.phone,
              maxLength: 10,
              prefixText: '+94',
              labelText: 'Mobile Number',
              prefixIcon: Icons.call,
              controller: phoneNumberController,
            ),
            SizedBox(height: size.height * 0.030),
            GenericInputOptionSelect(
              width: size.width,
              labelText: ' Role',
              dropDownValue: role,
              itemList: roleList,
              borderColor: AppColors.ash,
              onValueChange: (text) => handleRole(text),
            ),
            SizedBox(height: size.height * 0.015),
            //Terms and conditions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: isAcceptsTermsAndConditons,
                  onChanged: (bool value) {
                    setState(() {
                      isAcceptsTermsAndConditons = value;
                    });
                  },
                ),
                TextButton(
                  child: Text('Terms and condtions'),
                  onPressed: () {
                    showTermsAndConditions();
                  },
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            GenericButton(
              isDisabled: !isAcceptsTermsAndConditons,
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Next',
              onPressed: () {
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    phoneNumberController.text.isEmpty ||
                    role.toString().isEmpty ||
                    city == null) {
                  fillRequiredFields('Fill All Required Fields');
                  return;
                }

                formattedNumber = formattedPhone(phoneNumberController.text);
                if (formattedNumber == null) {
                  fillRequiredFields('Phone number invalid');
                  return;
                }
                isNumberAlreadyHaveAccount(formattedNumber);
              },
              isBold: true,
            )
          ],
        ));
  }
}
