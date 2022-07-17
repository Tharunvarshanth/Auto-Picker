import 'dart:async';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage();

  _OtpLoginPage createState() => _OtpLoginPage();
}

class _OtpLoginPage extends State<OtpLoginPage> with CodeAutoFill {
  final scaffoldKey = GlobalKey();
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

  String _otpCode = "";
  String Appsignature = "{{ app signature }}";

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        Appsignature = signature;
      });
    });
  }

  @override
  void codeUpdated() {
    print("code Updated");
    setState(() {
      _otpCode = code;
    });
    autoOtpSubmit(code);
  }

  void redirect(UserCredential user) async {
    var _user = await userController.getUser((user.user.uid));

    await userInfo.saveUser(
        true, user.user.uid, user.user.phoneNumber, '', _user["role"]);
    navigate(context, RouteGenerator.homePage);
  }

  //testng devices
  void autoOtpSubmit(String code) async {
    setState(() {
      isLoading = true;
    });
    try {
      await auth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: code))
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
                  .then((results) {})
                  .catchError((error) {});
            }

            await userInfo.saveUser(
                true, value.user.uid, value.user.phoneNumber, '', user["role"]);
            navigate(context, RouteGenerator.homePage);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('The provided phone number is not valid. ${e}');
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

  @override
  Future<void> dispose() async {
    SmsAutoFill().unregisterListener();
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Stack(children: [
          if (isLoading)
            Align(
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
            margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 0.0),
            child: Image.asset(
              "assets/images/phone-number-input.png",
              scale: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 240, 10, 50),
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
                    SizedBox(height: 30),
                    GenericTextField(
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: _numberController,
                      prefixText: '+94',
                      labelText: "Mobile Number",
                      prefixIcon: Icons.call,
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
                              fillRequiredFields(
                                  'Phone number connot be empty');
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
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 25, 50, 10),
                        child: GenericText(
                          text: 'Verify Phone',
                          isBold: true,
                          textSize: 30,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 25, 50, 10),
                        child: Text(
                          'Code is send to ${formattedNumber}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[800]),
                        ),
                      ),
                      SizedBox(height: 2),
                      PinFieldAutoFill(
                          decoration: UnderlineDecoration(
                            gapSpace: 10,
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.black),
                            colorBuilder: FixedColorBuilder(
                                Colors.black.withOpacity(0.3)),
                          ),
                          currentCode: _otpCode,
                          onCodeSubmitted: (prop) =>
                              {}, //code submitted callback
                          onCodeChanged: (prop) {
                            if (prop.length == 6) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                          codeLength: 6 //code length, default 6
                          ),
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
                          text: "Didn't receive code? Request again",
                          color: AppColors.Blue,
                          isBold: true,
                          onPressed: () => _verifyPhone(formattedNumber),
                        )
                    ],
                  ),
          ),
        ]),
      ),
    ));
  }
}
