import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/mechanics_sign_up_form.dart';
import 'package:auto_picker/models/Location.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              text: 'Hi, Mechanics',
              textSize: 36,
              isBold: true,
            ),
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: SvgPicture.asset('assets/images/mechanic-svgrepo-com.svg'),
            ),
            const SizedBox(
              height: 1,
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
