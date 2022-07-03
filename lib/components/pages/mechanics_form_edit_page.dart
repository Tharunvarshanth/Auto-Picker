import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/mechanics_sign_up_edit_form.dart';
import 'package:auto_picker/models/Location.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MechanicsFormEditPage extends StatefulWidget {
  UserModel userModel;
  Mechanic mechanic;
  MechanicsFormEditPage({Key key, this.userModel, this.mechanic})
      : super(key: key);

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
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child:
                    SvgPicture.asset('assets/images/mechanic-svgrepo-com.svg'),
              ),
              GenericText(
                text: 'Hi, Mechanics',
                textSize: 36,
                isBold: true,
              ),
              SizedBox(
                height: 1,
              ),
              GenericText(
                text: 'As a Mechanics you can update your informations',
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
        )
      ]),
    )));
  }
}
