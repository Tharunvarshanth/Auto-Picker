import 'dart:async';

import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_order.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/single_digit_field.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage();

  _OtpLoginPage createState() => _OtpLoginPage();
}

class _OtpLoginPage extends State<OtpLoginPage> {
  var d1 = TextEditingController();
  var d2 = TextEditingController();
  var d3 = TextEditingController();
  var d4 = TextEditingController();
  var d5 = TextEditingController();
  var d6 = TextEditingController();
  var userInfo = UserInfoCache();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationCode;
  TextEditingController _numberController;
  bool isOtpScreen = false;
  var userController = UserController();
  var addUserRes;
  bool isLoading = false;
  bool isResend = false;
  bool isvalidUser = true;
  int timerCount = 60;
  Timer _timer;
  String formattedNumber;

  void initState() {
    super.initState();
    _numberController = TextEditingController();
  }

  void autoFill() {
    d1.text = _verificationCode[0];
    d2.text = _verificationCode[1];
    d3.text = _verificationCode[2];
    d4.text = _verificationCode[3];
    d5.text = _verificationCode[4];
    d6.text = _verificationCode[5];
    setState(() {
      isLoading = true;
    });
    autoOtpSubmit();
  }

  void redirect(UserCredential user) async {
    var _user = await userController.getUser((user.user.uid));
    print(_user['role']);
    await userInfo.saveUser(
        true, user.user.uid, user.user.phoneNumber, '', _user["role"]);
    navigate(context, RouteGenerator.homePage);
  }

  //testng devices
  void autoOtpSubmit() async {
    setState(() {
      isLoading = true;
    });
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: '123456'))
          .then((user) async => {
                //sign in was success
                if (user != null)
                  {
                    redirect(user),
                  }
              })
          // ignore: invalid_return_type_for_catch_error
          .catchError((error) => {
                setState(() {
                  isLoading = false;
                }),
              });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> isNumberAlreadyHaveAccount(String number) async {
    var res = await userController.isNumberAlreadyHaveAccount(number);
    print("res:isNumberAlreadyHaveAccount ${res}");
    if (res) {
      isOtpScreen = true;
      _verifyPhone(number);
    } else {
      isvalidUser = true;
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Login Failure',
                bodyText:
                    "We didn't find any records for this number so try signup with this number",
                primaryButtonText: 'Sign Up',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.signUpPage),
                secondaryButtonText: 'Ok',
                onPressedSecondary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  void _verifyPhone(String number) async {
    timerCount = 60;
    startTimer();
    var testingNumber = number;
    await auth.verifyPhoneNumber(
      phoneNumber: testingNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          timerCount = 0;
          isLoading = true;
        });
        auth.signInWithCredential(credential).then((value) async {
          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential
          if (value.user != null) {
            var user = await userController.getUser((value.user.uid));
            void setOneSignalToken() async {
// Setting External User Id with Callback Available in SDK Version 3.9.3+
              OneSignal.shared
                  .setExternalUserId(value.user.uid)
                  .then((results) {
                print("setExternalUserId ${results.toString()}");
              }).catchError((error) {
                print("setExternalUserId:e ${error.toString()}");
              });
            }

            await userInfo.saveUser(
                true, value.user.uid, value.user.phoneNumber, '', user["role"]);
            navigate(context, RouteGenerator.homePage);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          showDialog(
              context: context,
              builder: (context) => ItemDialogMessage(
                    icon: 'assets/images/x-circle.svg',
                    titleText: 'Login Failure',
                    bodyText: "The provided phone number is not valid.",
                    primaryButtonText: 'OK',
                    onPressedPrimary: () =>
                        navigate(context, RouteGenerator.loginPage),
                  ));
        }
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int resendToken) {
        print("codeSent ${verificationId}");
        setState(() {
          _verificationCode = verificationId;
        });
        autoFill();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout ${verificationId}");
        setState(() {
          timerCount = 0;
          _verificationCode = '';
          isLoading = false;
        });
      },
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timerCount == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            timerCount--;
          });
        }
      },
    );
  }

  void fillRequiredFields(String title) {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: title,
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  String formattedPhone(String text) {
    String phonenumber = text.trim();
    if (phonenumber.length == 10) {
      return "+94" + phonenumber.substring(1);
    }
    if (phonenumber.length == 9) {
      phonenumber = phonenumber;
      return "+94" + phonenumber;
    }
    return null;
  }

  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        if (isLoading)
          Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppColors.blue,
              )),
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
        Container(
          alignment: Alignment.center,
          height: 200,
          margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
          child: Image.asset(
            "assets/images/phone-number-input.png",
            scale: 0.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 225, 10, 50),
          child: !isOtpScreen
              ? Column(children: [
                  Text(
                    'Enter the Phone Number ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        prefixText: '+94',
                        prefixStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Phone number here',
                        labelStyle: TextStyle(
                          fontSize: 15,
                        )),
                    controller: _numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: GenericButton(
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.white,
                        text: 'Submit',
                        textsize: 15,
                        isBold: true,
                        paddingVertical: 20,
                        onPressed: () {
                          if (_numberController.text.isEmpty) {
                            fillRequiredFields('Phone number connot be empty');
                            return;
                          }
                          formattedNumber =
                              formattedPhone(_numberController.text);
                          if (formattedNumber == null) {
                            fillRequiredFields('Phone number invalid');
                            return;
                          } else {
                            //validate phone number submit redirect to firebase login
                            isNumberAlreadyHaveAccount(formattedNumber);
                          }
                        },
                      )),
                ])
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: GenericText(
                        text: 'Otp Login',
                        isBold: true,
                        textSize: 30,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 10),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d1,
                              ),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d2,
                              ),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d3,
                              ),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d4,
                              ),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d5,
                              ),
                              SingleDigitField(
                                widthPercentage: 0.1,
                                fontSize: 16,
                                controller: d6,
                              ),
                            ])),
                    SizedBox(height: 2),
                    GenericText(
                      text: 'Resend timer ',
                    ),
                    GenericText(
                      text: timerCount.toString(),
                      isBold: true,
                    ),
                    if (timerCount == 0)
                      GenericTextButton(
                        text: ' Resend',
                        color: AppColors.Blue,
                        isBold: true,
                        onPressed: () => _verifyPhone(formattedNumber),
                      )
                  ],
                ),
        ),
      ]),
    ));
  }
}
