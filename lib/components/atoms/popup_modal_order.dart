import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'generic_button.dart';

class PopUpModalOrder extends StatelessWidget {
  String icon;
  String titleText;
  String bodyText;
  String primaryButtonText;
  String secondaryButtonText;
  bool Function() onPressedPrimary;
  bool Function() onPressedSecondary;
  TextEditingController controller = TextEditingController();
  PopUpModalOrder(
      {Key key,
      this.icon,
      this.titleText,
      this.bodyText,
      this.primaryButtonText,
      this.secondaryButtonText,
      this.onPressedPrimary,
      this.onPressedSecondary,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenericText(
                text: titleText,
                textSize: 24,
                isBold: true,
              ),
              Image(
                image: AssetImage(icon),
                width: 150,
                height: 75,
              ),
              const SizedBox(
                height: 10,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth * 0.33,
                    child: TextField(
                      controller: controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                bodyText ?? 'Dialog',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: primaryButtonText ?? 'Done',
                  onPressed: onPressedPrimary,
                  borderRadius: 30,
                  shadowColor: Colors.white,
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: secondaryButtonText ?? 'CANCEL',
                  onPressed: onPressedSecondary,
                  borderColor: Colors.white,
                  textColor: AppColors.Blue,
                  shadowColor: Colors.white,
                  backgroundColor: AppColors.white,
                  elevation: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
