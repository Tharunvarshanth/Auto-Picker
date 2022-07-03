import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/seller_edit_form.dart';
import 'package:auto_picker/components/organisms/seller_sign_up_form.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';
import 'package:flutter_svg/svg.dart';

class SellerEditPage extends StatefulWidget {
  UserModel userModel;
  Seller seller;
  SellerEditPage({this.userModel, this.seller});

  @override
  _SellerEditPageState createState() => _SellerEditPageState();
}

class _SellerEditPageState extends State<SellerEditPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
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
      Padding(
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
            GenericText(
              text: 'You can edit shop related data',
              textSize: 18,
            ),
            const SizedBox(
              height: 30,
            ),
            SellerEditForm(userModel: widget.userModel, seller: widget.seller)
          ],
        ),
      ),
    ]))));
  }
}
