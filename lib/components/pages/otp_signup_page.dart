import 'dart:async';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/single_digit_field.dart';
import 'package:auto_picker/components/pages/google_signin_login_page.dart';
import 'package:auto_picker/components/pages/user_payment_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/feedback_controller.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/services/order_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/services/vehicle_service_record_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpSignUpPage extends StatefulWidget {
  final Map<String, String> params;
  const OtpSignUpPage({Map<String, String> this.params});

  @override
  _OtpSignUpPageState createState() => _OtpSignUpPageState();
}

class _OtpSignUpPageState extends State<OtpSignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationCode;
  var userController = UserController();
  var mechanicController = MechanicController();
  var sellerController = SellerController();
  var orderController = OrderController();
  var notificationController = NotificationController();
  var vehicleServiceHistoryController = VehicleServiceController();
  var userInfo = UserInfoCache();
  var addUserRes;
  bool isLoading = false;
  bool isResend = false;
  int timerCount = 60;
  Timer _timer;
  bool isvalidUser = true;

  var productController = ProductController();
  var advertisementController = AdvertisementController();
  var mFeedbackController = FeedBackController();

  var d1 = TextEditingController();
  var d2 = TextEditingController();
  var d3 = TextEditingController();
  var d4 = TextEditingController();
  var d5 = TextEditingController();
  var d6 = TextEditingController();

  FocusNode nodeFirst = FocusNode();
  FocusNode nodeSecond = FocusNode();
  FocusNode nodeThird = FocusNode();
  FocusNode nodeFourth = FocusNode();
  FocusNode nodeFifth = FocusNode();
  FocusNode nodeSixth = FocusNode();

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  Future<bool> isNumberAlreadyHaveAccount() async {
    var number = widget.params["phoneNumber"];
    var res = await userController.isNumberAlreadyHaveAccount(number);
    print("res:isNumberAlreadyHaveAccount ${res}");
    if (!res) {
      _verifyPhone();
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Login Failure',
                bodyText:
                    "This number already have an account try to signup with new number",
                primaryButtonText: 'Sign Up',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.signUpPage),
                secondaryButtonText: 'Ok',
                onPressedSecondary: () => Navigator.pop(context, 'Cancel'),
              ));
      isvalidUser = true;
    }
  }

  void storeDB(String fireUser) async {
    var user = UserModel(
        widget.params["name"],
        fireUser,
        widget.params["phoneNumber"],
        '',
        widget.params["role"],
        '',
        widget.params["city"],
        widget.params["address"],
        false);
    // adding user info in common db collection
    var resUser = await userController.addUser(user);
    externalAllTestData(fireUser);
    var resOther = true;
    switch (widget.params["role"]) {
      case Users.Mechanic:
        {
          var mechanic = Mechanic(
              widget.params["workingAddress"],
              fireUser,
              widget.params["workingCity"],
              widget.params["workingTime_To"],
              widget.params["workingTime_From"],
              widget.params["specialist"],
              widget.params["accountCreatedDate"] = DateTime.now().toString(),
              false,
              widget.params["location-lat"],
              widget.params["location-lon"],
              false,
              widget.params["name"]);
          await mFeedbackController.addTestFeedback(fireUser);
          await mechanicController.addMechanic(mechanic);
        }
        break;
      case Users.Seller:
        {
          var seller = Seller(
              widget.params["shopName"],
              fireUser,
              widget.params["shopAddress"],
              widget.params["shopcity"],
              widget.params["shopPhoneNumber"],
              widget.params["accountCreatedDate"] = DateTime.now().toString(),
              false,
              false);
          resOther = await sellerController.addSeller(seller);
          externalSellerTestData(fireUser);
        }
        break;
      default:
        {}
        break;
    }
    setState(() {
      isLoading = false;
    });
    if (resUser && resOther) {
      OneSignal.shared.setExternalUserId(fireUser).then((results) {
        print("setExternalUserId ${results.toString()}");
      }).catchError((error) {
        print("setExternalUserId:e ${error.toString()}");
      });

      switch (widget.params["role"]) {
        case Users.Mechanic:
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserSignUpPaymentPage(id: fireUser, isSeller: false),
              ),
            );
          }
          break;
        case Users.Seller:
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserSignUpPaymentPage(id: fireUser, isSeller: true),
              ),
            );
          }
          break;
        default:
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GoogleLinkingPage(
                  isLinkingPage: true,
                ),
              ),
            );
          }
          break;
      }
    } else {
      // error pop up
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Signup Failure',
                bodyText: "Your Signup was unsuccessful please try again",
                primaryButtonText: 'Sign Up',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.signUpPage),
                secondaryButtonText: 'Ok',
                onPressedSecondary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  void externalSellerTestData(String uid) async {
    Future.wait([
      productController.addProductTest(uid),
      advertisementController.addTestAdvertisment(uid),
      orderController.addTestOrder(uid)
    ]);
  }

  void externalAllTestData(String uid) async {
    Future.wait([
      notificationController.addNotificationTest(uid),
      vehicleServiceHistoryController.addVehicleServiceTest(uid)
    ]);
  }

  void authComplete(resUser, resOther, fireUser) {
    setState(() {
      isLoading = false;
    });
    if (resUser && resOther) {
      userInfo.saveUser(true, fireUser, widget.params["phoneNumber"], "",
          widget.params["role"]);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GoogleLinkingPage(
            isLinkingPage: true,
          ),
        ),
      );
      //Navigate to home
    } else {
      // error pop up
    }
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
                    print("sign up user:1 ${user.user.uid}"),
                    storeDB(user.user.uid)
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

  void autoFill() {
    setState(() {
      isLoading = true;
    });
    autoOtpSubmit(d1.text + d2.text + d3.text + d4.text + d5.text + d6.text);
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

  void authCredential(credential) async {
    await auth.signInWithCredential(credential).then((value) async {
      print("value" + value.toString());
      if (value.user != null) {
        storeDB(value.user.uid);
      }
    });
  }

  void _verifyPhone() async {
    setState(() {
      timerCount = 60;
    });
    startTimer();
    var testingNumber = widget.params["phoneNumber"];
    await auth.verifyPhoneNumber(
      phoneNumber: testingNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          timerCount = 0;
          isLoading = true;
        });
        print("signup success " + credential.toString());
        _timer.cancel();
        authCredential(credential);
        /*
        auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            storeDB(value.user.uid);
          }
        });*/
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
        timerCount = 60;
        startTimer();
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

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

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
        icon: const Icon(Icons.arrow_back),
        color: AppColors.black,
        onPressed: () {
          navigateBack(context);
        },
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20, 100, 10, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GenericText(
              text: 'Welcome',
              isBold: true,
              textSize: 30,
            ),
            GenericText(
              maxLines: 3,
              text:
                  'Enter the 6 digit code you will to your number ${widget.params["phoneNumber"]}',
              textSize: 18,
            ),
            SizedBox(height: 2),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SingleDigitField(
                        focusNode: nodeFirst,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d1,
                        onChanged: (value) => {
                          if (value != '')
                            {FocusScope.of(context).requestFocus(nodeSecond)}
                        },
                      ),
                      SingleDigitField(
                        focusNode: nodeSecond,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d2,
                        onChanged: (value) => {
                          if (value != '')
                            {FocusScope.of(context).requestFocus(nodeThird)}
                        },
                      ),
                      SingleDigitField(
                        focusNode: nodeThird,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d3,
                        onChanged: (value) => {
                          if (value != '')
                            {FocusScope.of(context).requestFocus(nodeFourth)}
                        },
                      ),
                      SingleDigitField(
                        focusNode: nodeFourth,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d4,
                        onChanged: (value) => {
                          if (value != '')
                            {FocusScope.of(context).requestFocus(nodeFifth)}
                        },
                      ),
                      SingleDigitField(
                        focusNode: nodeFifth,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d5,
                        onChanged: (value) => {
                          if (value != '')
                            {FocusScope.of(context).requestFocus(nodeSixth)}
                        },
                      ),
                      SingleDigitField(
                        focusNode: nodeSixth,
                        widthPercentage: 0.1,
                        fontSize: 16,
                        controller: d6,
                        onChanged: (value) => {
                          if (value != '') {autoFill()}
                        },
                      ),
                    ])),
            GenericText(
              text: 'Resend timer ',
            ),
            GenericText(
              text: timerCount.toString(),
              isBold: true,
            ),
            SizedBox(height: 2),
            if (timerCount == 0)
              GenericTextButton(
                text: ' Resend',
                color: AppColors.Blue,
                isBold: true,
                onPressed: () => _verifyPhone(),
              )
          ],
        ),
      )
    ])));
  }
}
