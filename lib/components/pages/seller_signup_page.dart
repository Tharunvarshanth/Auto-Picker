import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/seller_sign_up_form.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';

class SellerSignUpPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const SellerSignUpPage({Map<String, String> this.params});

  @override
  _SellerSignUpPageState createState() => _SellerSignUpPageState();
}

class _SellerSignUpPageState extends State<SellerSignUpPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      IconButton(
        padding: EdgeInsets.all(12),
        iconSize: 40,
        alignment: Alignment.topLeft,
        icon: const Icon(Icons.arrow_back),
        color: AppColors.black,
        onPressed: () {
          navigateBack(context);
        },
      ),
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 75, 10, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GenericText(
              text: 'Hi, Seller',
              textSize: 36,
              isBold: true,
            ),
            GenericText(
              maxLines: 3,
              text:
                  'As a Seller we need an additional information for you please fill below form complete the registration',
              textSize: 18,
            ),
            const SizedBox(
              height: 30,
            ),
            SellerSignUpForm(
              params: widget.params,
            )
          ],
        ),
      ),
    ])));
  }
}
