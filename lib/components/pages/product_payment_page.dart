import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/admin_controller.dart';
import 'package:auto_picker/services/payhere_services.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class ProductPaymentPage extends StatefulWidget {
  String productId;

  ProductPaymentPage({
    this.productId,
  });

  @override
  _ProductPaymentPageState createState() => _ProductPaymentPageState();
}

class _ProductPaymentPageState extends State<ProductPaymentPage> {
  var payhereService = PayhereService();
  var adminControl = AdminController();
  var userController = UserController();
  var productController = ProductController();
  var existingUser = FirebaseAuth.instance.currentUser;
  String payment;
  void initState() {
    super.initState();
    getCharges();
  }

  getCharges() async {
    var res = (await adminControl.getAdmin())["productPaymentCharge"];
    setState(() {
      payment = res;
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
                  titleText: title,
                  bodyText: msg,
                  primaryButtonText:
                      "Payment Success!" == title ? 'Ok' : "Retry",
                  onPressedPrimary: () {
                    if ("Payment Success!" == title) {
                      navigate(context, RouteGenerator.homePage);
                      return;
                    }
                    Navigator.pop(context, 'Cancel');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPaymentPage(
                            productId: widget.productId,
                          ),
                        ));
                  },
                  secondaryButtonText:
                      "Payment Success!" != title ? 'Go Home' : null,
                  onPressedSecondary: () {
                    if ("Payment Success!" != title) {
                      navigate(context, RouteGenerator.homePage);
                    }
                  },
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
        user.id,
        user.id,
        payment,
        user.fullName,
        user.fullName,
        user.email,
        existingUser.phoneNumber,
        user.address,
        user.city);
    PayHere.startPayment(paymentObject, (paymentId) async {
      print("One Time Payment Success. Payment Id: $paymentId");
      var res = productController.updateProduct(
          user.id, widget.productId, 'isPayed', true);
      showAlert(context, "Payment Success!", "Payment Id: $paymentId ");
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Payment',
          isLogged: true,
          showBackButton: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
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
              text: 'Your charge is $payment',
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
            const SizedBox(
              height: 20,
            ),
            GenericText(
              textAlign: TextAlign.center,
              maxLines: 4,
              textSize: 18,
              text: 'Your product will be  live after the payment',
            ),
          ],
        )));
  }
}
