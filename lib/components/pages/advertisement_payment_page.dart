import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/admin_controller.dart';
import 'package:auto_picker/services/payhere_services.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  String payment = '';
  bool isLoading = true;
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
                  icon: 'assets/images/done.svg',
                  titleText: title,
                  bodyText: msg,
                  primaryButtonText: 'Ok',
                  onPressedPrimary: () =>
                      navigate(context, RouteGenerator.homePage),
                ));
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
      var res = await advertismentController.updateManyAdvertisement(user.id,
          widget.params["adId"], {'isPaymentDone': true, 'payment': paymentId});
      print("One Time Payment Success. Payment Id: $paymentId $res");
      showAlert(context, "Payment Success!", "Payment Id: $paymentId ");
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {
      print("Thank you for your payment");
    });
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
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GenericText(
                    textAlign: TextAlign.center,
                    isBold: true,
                    textSize: 24,
                    text: 'Your advertisement charge $payment',
                  ),
                  GenericButton(
                    text: 'Pay Now',
                    textColor: AppColors.white,
                    backgroundColor: AppColors.Blue,
                    onPressed: () => payNow(context),
                  )
                ],
              )));
  }
}
