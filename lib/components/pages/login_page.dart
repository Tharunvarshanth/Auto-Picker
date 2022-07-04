import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/pages/google_signin_login_page.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        IconButton(
          padding: EdgeInsets.all(12),
          iconSize: 40,
          alignment: Alignment.topLeft,
          icon: Image.asset(
            "assets/images/back-arrow.png",
            scale: 1.2,
          ),
          onPressed: () {
            navigateBack(context);
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 10, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Login to your Account",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.values[0],
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: GenericButton(
                          backgroundColor: AppColors.blue,
                          textColor: AppColors.white,
                          text: 'LOGIN WITH MOBILE NUMBER',
                          textsize: 15,
                          isBold: true,
                          paddingVertical: 20,
                          onPressed: () {
                            navigate(context, RouteGenerator.otpLogin);
                          },
                        )),
                    const SizedBox(
                      //Use of SizedBox
                      height: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: GenericButton(
                          backgroundColor: AppColors.green,
                          textColor: AppColors.white,
                          textsize: 15,
                          text: 'LOGIN WITH EMAIL',
                          paddingVertical: 20,
                          isBold: true,
                          paddingHorizontal: 50,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoogleLinkingPage(
                                  isLinkingPage: false,
                                ),
                              ),
                            );
                          },
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GenericText(
                          text: 'Don\'t have an Account? ',
                          isBold: true,
                          textSize: 14,
                        ),
                        GenericTextButton(
                          text: 'Sign up',
                          isBold: true,
                          textSize: 15,
                          color: AppColors.blue,
                          onPressed: () {
                            navigate(context, RouteGenerator.signUpPage);
                          },
                        )
                      ],
                    )
                  ]),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 200,
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Image.asset(
                  "assets/images/login.png",
                  fit: BoxFit.contain,
                  scale: 0.5,
                ),
              ),
            ],
          ),
        )
      ],
    )));
  }
}
