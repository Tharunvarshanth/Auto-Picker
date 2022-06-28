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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 10, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 200,
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: Image.asset(
                        "assets/images/signup2.png",
                        scale: 0.5,
                      ),
                    ),
                    // SizedBox(
                    //   height: size.height * 0.015,
                    // ),
                    Text(
                      "Sign up",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Text(
                      "Register your Account",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.020,
                    ),
                    SignUpForm()
                  ],
                ),
              ),
            ])));
  }
}
