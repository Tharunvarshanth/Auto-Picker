import 'dart:async';
import 'dart:convert';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/pages/mechanics_form_edit_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_edit_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditSignUpForm extends StatefulWidget {
  final UserModel userModel;
  Seller seller;
  Mechanic mechanic;
  EditSignUpForm({this.userModel, this.seller, this.mechanic});
  @override
  _EditSignUpFormState createState() => _EditSignUpFormState();
}

class _EditSignUpFormState extends State<EditSignUpForm> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  var userController = UserController();
  String city;
  String role;
  bool isvalidUser = false;

  void initState() {
    nameController.text = widget.userModel.fullName;
    addressController.text = widget.userModel.address;
    city = widget.userModel.city;
    role = widget.userModel.role;
  }

  void handleCity(cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleNext() {
    widget.userModel.fullName = nameController.text;
    widget.userModel.address = addressController.text;
    widget.userModel.city = city;

    switch (role) {
      case Users.Mechanic:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MechanicsFormEditPage(
              userModel: widget.userModel,
              mechanic: widget.mechanic,
            ),
          ),
        );
        break;
      case Users.Seller:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SellerEditPage(
                userModel: widget.userModel, seller: widget.seller),
          ),
        );
        break;
      case Users.NormalUser:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> roleList = [Users.Mechanic, Users.NormalUser, Users.Seller];
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
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'City',
              value: city,
              itemList: cityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.035),
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
