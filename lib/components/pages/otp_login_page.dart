import 'dart:async';

import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
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
                    print("sign in user:1 ${user.user.phoneNumber}"),
                    await userInfo.saveUser(
                        true, user.user.uid, user.user.phoneNumber, ''),
                    navigate(context, RouteGenerator.homePage)
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

  Future<bool> isNumberAlreadyHaveAccount() async {
    var number = TESTNUMBER; //_numberController.text ;
    var res = await userController.isNumberAlreadyHaveAccount(number);
    print("res:isNumberAlreadyHaveAccount ${res}");
    if (res) {
      isOtpScreen = true;
      timerCount = 60;
      startTimer();
      _verifyPhone();
    } else {
      isvalidUser = true;
    }
  }

  void _verifyPhone() async {
    var testingNumber = "+94 076 8407950";
    await auth.verifyPhoneNumber(
      phoneNumber: testingNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          timerCount = 0;
          isLoading = true;
        });
        auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            await userInfo.saveUser(
                true, value.user.uid, value.user.phoneNumber, '');
            navigate(context, RouteGenerator.homePage);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
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

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        if (isLoading) CircularProgressIndicator(),
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
        Padding(
          padding: EdgeInsets.fromLTRB(10, 100, 10, 50),
          child: !isOtpScreen
              ? Column(children: [
                  GenericText(
                    text: 'Enter the Phone Number ',
                    isBold: true,
                    textSize: 30,
                  ),
                  GenericTextField(
                    controller: _numberController,
                    inputType: TextInputType.phone,
                    labelText: '',
                    hintText: "077 - 1234567",
                    borderColor: AppColors.ash,
                  ),
                  GenericButton(
                    text: 'Submit',
                    paddingVertical: 20,
                    onPressed: () => isNumberAlreadyHaveAccount(),
                  )
                ])
              : Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                      )
                  ],
                ),
        ),
      ]),
    ));
  }
}
