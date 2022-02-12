import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/mechanics_sign_up_edit_form.dart';
import 'package:auto_picker/components/organisms/mechanics_sign_up_form.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/models/Location.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';
import 'package:intl/intl.dart';

class MechanicsFormEditPage extends StatefulWidget {
  UserModel userModel;
  Mechanic mechanic;
  MechanicsFormEditPage({this.userModel, this.mechanic});

  @override
  _MechanicsFormEditPageState createState() => _MechanicsFormEditPageState();
}

class _MechanicsFormEditPageState extends State<MechanicsFormEditPage> {
  Location location = new Location();

  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
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
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 75, 10, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GenericText(
              text: 'Hi, Mechanics',
              textSize: 36,
              isBold: true,
            ),
            SizedBox(
              height: 1,
            ),
            GenericText(
              text: 'As a Mechanics you update you informations',
              textSize: 16,
            ),
            SizedBox(
              height: 30,
            ),
            MechanicsSignUpEditForm(
              userModel: widget.userModel,
              mechanic: widget.mechanic,
            )
          ],
        ),
      ),
    ])));
  }
}
