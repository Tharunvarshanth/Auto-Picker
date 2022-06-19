import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void initState() {}

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              IconButton(
                padding: EdgeInsets.all(12),
                iconSize: 36,
                alignment: Alignment.topLeft,
                icon: const Icon(Icons.arrow_back),
                color: AppColors.black,
                onPressed: () {
                  print("1");
                  navigateBack(context);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 10, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GenericText(
                      text: 'Sign Up',
                      textSize: 36,
                      isBold: true,
                    ),
                    GenericText(
                      textAlign: TextAlign.left,
                      text: 'Required *',
                      color: AppColors.red,
                      isBold: true,
                    ),
                    SignUpForm()
                  ],
                ),
              ),
            ])));
  }
}
