import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/seller_sign_up_form.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SellerSignUpPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const SellerSignUpPage({Map<String, String> this.params});

  @override
  _SellerSignUpPageState createState() => _SellerSignUpPageState();
}

class _SellerSignUpPageState extends State<SellerSignUpPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
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
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 75, 10, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GenericText(
              text: 'Hi, Seller',
              textSize: 36,
              isBold: true,
            ),
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child:
                  SvgPicture.asset('assets/images/online-shop-svgrepo-com.svg'),
            ),
            const SizedBox(
              height: 30,
            ),
            GenericText(
              maxLines: 3,
              text:
                  'As a Seller we need an additional information for you please fill below form complete the registration',
              textSize: 18,
            ),
            const SizedBox(
              height: 30,
            ),
            SellerSignUpForm(
              params: widget.params,
            )
          ],
        ),
      ),
    ])));
  }
}
