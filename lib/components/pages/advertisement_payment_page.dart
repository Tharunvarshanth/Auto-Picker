import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/admin_controller.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/services/payhere_services.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class AdvertisementPaymentPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const AdvertisementPaymentPage({this.params});

  @override
  _AdvertisementPaymentPageState createState() =>
      _AdvertisementPaymentPageState();
}

class _AdvertisementPaymentPageState extends State<AdvertisementPaymentPage> {
  var payhereService = PayhereService();
  var adminControl = AdminController();
  var userController = UserController();
  var advertismentController = AdvertisementController();
  var existingUser = FirebaseAuth.instance.currentUser;
  var notificationController = NotificationController();
  String payment = '';
  bool isLoading = true;
  var pushMessagingService = PushMessagingSerivce();
  void initState() {
    super.initState();
    getAdvertisementCharges();
  }

  getAdvertisementCharges() async {
    var res = (await adminControl.getAdmin())["advertisementCharge"];
    setState(() {
      payment = res.toString();
    });
    setState(() {
      isLoading = false;
    });
  }

  void showAlert(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                icon: title == 'Payment Success!'
                    ? 'assets/images/done.svg'
                    : 'assets/images/x-circle.svg',
                titleText: "Payment Success!" == title ? 'Ok' : "Retry",
                bodyText: msg,
                primaryButtonText: 'Ok',
                onPressedPrimary: () {
                  if ("Payment Success!" == title) {
                    navigate(context, RouteGenerator.homePage);
                    return;
                  }
                  Navigator.pop(context, 'Cancel');
                  var params = {
                    'adId': widget.params["adId"],
                    'item': widget.params["item"],
                    'subTitle': widget.params['subTitle']
                  };
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdvertisementPaymentPage(
                          params: params,
                        ),
                      ));
                },
                secondaryButtonText:
                    "Payment Success!" != title ? 'Go Home' : null,
                onPressedSecondary: () {
                  if ("Payment Success!" != title) {
                    navigate(context, RouteGenerator.homePage);
                  }
                }));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  adEndDate() {
    return (DateTime.now().add(const Duration(days: 15)));
  }

  void payNow(BuildContext context) async {
    var user =
        UserModel.fromJson(await userController.getUser((existingUser.uid)));

    var paymentObject = payhereService.oneTimePayment(
        widget.params["adId"],
        widget.params["item"],
        payment,
        user.fullName,
        user.fullName,
        user.email,
        existingUser.phoneNumber,
        user.address,
        user.city);
    PayHere.startPayment(paymentObject, (paymentId) async {
      var res = await advertismentController.updateManyAdvertisement(
          user.id, widget.params["adId"], {
        'isPaymentDone': true,
        'payment': paymentId,
        'endDate': adEndDate().toString()
      });
      print("One Time Payment Success. Payment Id: $paymentId $res");
      showAlert(context, "Payment Success!", "Payment Id: $paymentId ");
      sendAdvertismentPushNotifications();
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {
      print("Thank you for your payment");
    });
    sendAdvertismentPushNotifications();
  }

  void sendAdvertismentPushNotifications() async {
    print("push for advertisment");
    List<String> userList = [];
    var res = await userController.getUsers();
    res.forEach((element) {
      userList.add(element["id"]);
    });
    print("push for advertisment ITEM ${widget.params["item"]}");
    pushMessagingService.sendAdvertisement(
        userList, widget.params["item"], widget.params['subTitle']);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Payment',
          isLogged: true,
          showBackButton: true,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                    height: 200,
                    margin:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: Image.asset(
                      "assets/images/money.png",
                      scale: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GenericText(
                    textAlign: TextAlign.center,
                    isBold: true,
                    textSize: 24,
                    text: 'Your advertisement charge $payment',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GenericButton(
                    text: 'Pay Now',
                    textColor: AppColors.white,
                    backgroundColor: AppColors.Blue,
                    onPressed: () => payNow(context),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GenericText(
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    textSize: 18,
                    text: 'Your ad will be deleted after 15 days of payment',
                  ),
                ],
              ));
  }
}
