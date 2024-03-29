import 'dart:async';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';

class SellerEditForm extends StatefulWidget {
  UserModel userModel;
  Seller seller;
  SellerEditForm({this.userModel, this.seller});
  @override
  _SellerEditFormState createState() => _SellerEditFormState();
}

class _SellerEditFormState extends State<SellerEditForm> {
  final shopNameController = TextEditingController();
  final shopNumberController = TextEditingController();
  final shopAddressController = TextEditingController();
  var userController = UserController();
  var sellerController = SellerController();
  List<City> dropDownCityList = [];
  City city;

  void initState() {
    setData();
    shopNameController.text = widget.seller.shopName;
    shopAddressController.text = widget.seller.address;
    shopNumberController.text = widget.seller.contactDetails;
    setState(() {
      city = City(city: widget.seller.city, code: '');
    });
  }

  void handleCity(cityName) {
    setState(() {
      city = cityName;
    });
  }

  void setData() async {
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
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

  void handleNext() {
    widget.seller.shopName = shopNameController.text;
    widget.seller.address = shopAddressController.text;
    widget.seller.contactDetails = shopNumberController.text;
    widget.seller.city = city.city;

    //update db
    Future.wait([
      userController.updateUser(widget.userModel),
      sellerController.updateSeller(widget.seller)
    ]).then((List<bool> res) {
      print(res[0]);
      if (res[0] && res[1]) {
        //popup
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/done.svg',
                  titleText: 'Succssfully updated',
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
            GenericTextField(
              controller: shopNameController,
              labelText: "Shop Name",
              prefixIcon: Icons.shop,
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              keyboardType: TextInputType.phone,
              maxLength: 11,
              controller: shopNumberController,
              labelText: "Phone Number",
              prefixIcon: Icons.call,
              prefixText: '+94',
            ),
            SizedBox(height: size.height * 0.015),
            GenericInputOptionCitysSelect(
              width: size.width,
              labelText: 'Working City',
              value: city,
              itemList: dropDownCityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.035),
            GenericTextField(
              controller: shopAddressController,
              labelText: "Shop Address",
              prefixIcon: Icons.streetview,
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
