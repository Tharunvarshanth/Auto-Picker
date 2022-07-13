import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
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
              labelText: 'City',
              value: city,
              itemList: dropDownCityList,
              onValueChange: (text) => handleCity(text),
            ),
            SizedBox(height: size.height * 0.015),
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
