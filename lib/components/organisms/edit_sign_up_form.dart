import 'dart:async';
import 'dart:convert';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/mechanics_form_edit_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_edit_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/models/city.dart';
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
  City city;
  String role;
  bool isvalidUser = false;
  List<City> dropDownCityList = [];

  void initState() {
    nameController.text = widget.userModel.fullName;
    addressController.text = widget.userModel.address;
    city = City(city: widget.userModel.city, code: ''); //widget.userModel.city;
    role = widget.userModel.role;
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
    widget.userModel.fullName = nameController.text;
    widget.userModel.address = addressController.text;
    widget.userModel.city = city.city;

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
        userController.updateUser(widget.userModel);
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/done.svg',
                  titleText: 'Successfully Updated',
                  bodyText: "",
                  primaryButtonText: 'Ok',
                  onPressedPrimary: () =>
                      navigate(context, RouteGenerator.profilePage),
                ));
        break;
      default:
        break;
    }
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
    nameController.dispose();
    addressController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> roleList = [Users.Mechanic, Users.NormalUser, Users.Seller];

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                  hintText: "Kamal",
                  labelStyle: TextStyle(fontSize: 15)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Name';
                }
                return null;
              },
            ),
            SizedBox(height: size.height * 0.015),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Address',
                  hintText: 'No 16,Galle Road',
                  labelStyle: TextStyle(fontSize: 15)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Name';
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
            SizedBox(height: size.height * 0.035),
            SizedBox(height: size.height * 0.015),
            GenericButton(
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Next',
              onPressed: () {
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
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
