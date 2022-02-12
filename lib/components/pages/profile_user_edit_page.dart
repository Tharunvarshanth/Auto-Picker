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
            child: Stack(children: [
      IconButton(
        padding: EdgeInsets.all(12),
        iconSize: 36,
        alignment: Alignment.topLeft,
        icon: const Icon(Icons.arrow_back),
        color: AppColors.black,
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
              text: 'User Edit',
              textSize: 36,
              isBold: true,
            ),
            EditSignUpForm(
                userModel: widget.userModel,
                seller: widget.seller,
                mechanic: widget.mechanic)
          ],
        ),
      ),
    ])));
  }
}
