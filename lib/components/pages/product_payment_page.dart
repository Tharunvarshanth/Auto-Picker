import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/google_signin_login_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/admin_controller.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/payhere_services.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
            GenericText(
              textAlign: TextAlign.center,
              isBold: true,
              textSize: 24,
              text: 'Your charge is $payment',
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
