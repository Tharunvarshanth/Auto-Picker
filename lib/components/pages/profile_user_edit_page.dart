import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/edit_sign_up_form.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';

class ProfileUserEditPage extends StatefulWidget {
  UserModel userModel;
  Seller seller;
  Mechanic mechanic;
  ProfileUserEditPage({this.userModel, this.mechanic, this.seller});

  @override
  _ProfileUserEditPageState createState() => _ProfileUserEditPageState();
}

class _ProfileUserEditPageState extends State<ProfileUserEditPage> {
  void initState() {
    super.initState();
  }

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
            Container(
              height: 150,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Image.asset(
                "assets/images/user-edit.png",
                scale: 0.5,
              ),
            ),
            Text(
              "User Edit",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            EditSignUpForm(
                userModel: widget.userModel,
                seller: widget.seller,
                mechanic: widget.mechanic)
          ],
        ),
      ),
    ]))));
  }
}
