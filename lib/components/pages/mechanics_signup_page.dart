import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/mechanics_sign_up_form.dart';
import 'package:auto_picker/components/organisms/sign_up_form.dart';
import 'package:auto_picker/models/Location.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';
import 'package:intl/intl.dart';

class MechanicsSignUpPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const MechanicsSignUpPage({Map<String, dynamic> this.params});

  @override
  _MechanicsSignUpPageState createState() => _MechanicsSignUpPageState();
}

class _MechanicsSignUpPageState extends State<MechanicsSignUpPage> {
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
            const SizedBox(
              height: 1,
            ),
            GenericText(
              maxLines: 3,
              text:
                  'As a Mechanics we need an additional information for you please fill below form complete the registration',
              textSize: 16,
            ),
            GenericText(
              textAlign: TextAlign.left,
              text: 'Required *',
              color: AppColors.red,
              isBold: true,
            ),
            const SizedBox(
              height: 30,
            ),
            MechanicsSignUpForm(params: widget.params)
          ],
        ),
      ),
    ])));
  }
}
