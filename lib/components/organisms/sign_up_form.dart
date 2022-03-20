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
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
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

  void initState() {
    super.initState();
    setData();
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

  void handleRole(roleName) {
    setState(() {
      role = roleName;
    });
  }

  Future<bool> isNumberAlreadyHaveAccount() async {
    var number = TESTNUMBER; //phoneNumberController.text ;
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
    print(city.city);
    if (isvalidUser) {
      var param = {
        'name': nameController.text,
        'address': addressController.text,
        'phoneNumber': TESTNUMBER, //phoneNumberController.text,
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
    List<String> roleList = [Users.Mechanic, Users.NormalUser, Users.Seller];
    /* List<String> cityList = [
      Users.Admin,
      Users.Mechanic,
      Users.NormalUser,
      Users.Seller
    ];*/
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            GenericTextField(
              controller: nameController,
              labelText: 'Name',
              hintText: "Kamal",
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: addressController,
              labelText: 'Address',
              hintText: 'No 16,Galle Road',
              borderColor: AppColors.ash,
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
            GenericTextField(
              controller: phoneNumberController,
              labelText: 'Phone Number',
              hintText: '077 - 1234567',
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'Role',
              value: role,
              itemList: roleList,
              borderColor: AppColors.ash,
              onValueChange: (text) => handleRole(text),
            ),
            SizedBox(height: size.height * 0.015),
            GenericButton(
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Next',
              onPressed: () {
                //validations ok
                isNumberAlreadyHaveAccount();
              },
              isBold: true,
            )
          ],
        ));
  }
}
