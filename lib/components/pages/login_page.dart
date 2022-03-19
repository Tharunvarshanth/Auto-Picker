import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/pages/google_signin_login_page.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
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
          icon: const Icon(Icons.arrow_back),
          color: AppColors.black,
          onPressed: () {
            navigateBack(context);
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/login.png"),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: GenericButton(
                          backgroundColor: AppColors.white,
                          textColor: AppColors.blue,
                          text: 'LOGIN WITH MOBILE NUMBER',
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: GenericButton(
                          backgroundColor: AppColors.white,
                          textColor: AppColors.green,
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
                        ))
                  ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenericText(
                    text: 'New User ?',
                  ),
                  GenericTextButton(
                    text: 'Sign Up',
                    color: AppColors.blue,
                    onPressed: () {
                      navigate(context, RouteGenerator.signUpPage);
                    },
                  )
                ],
              )
            ],
          ),
        )
      ],
    )));
  }
}
