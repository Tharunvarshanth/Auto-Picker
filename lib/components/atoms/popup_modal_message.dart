import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'generic_button.dart';

class ItemDialogMessage extends StatelessWidget {
  String icon;
  String titleText;
  String bodyText;
  String primaryButtonText;
  String secondaryButtonText;
  void Function() onPressedPrimary;
  void Function() onPressedSecondary;
  TextEditingController controller;
  ItemDialogMessage(
      {Key key,
      this.icon,
      this.titleText,
      this.bodyText,
      this.primaryButtonText,
      this.secondaryButtonText,
      this.onPressedPrimary,
      this.onPressedSecondary})
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
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(icon, height: 50, width: 50),
              const SizedBox(
                height: 10,
              ),
              if (controller != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth * 0.33,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
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
                bodyText ?? '',
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
                  text: primaryButtonText,
                  onPressed: onPressedPrimary,
                  borderRadius: 30,
                  shadowColor: Colors.white,
                  elevation: 0,
                  backgroundColor: AppColors.Blue,
                  textColor: Colors.white,
                ),
              ),
              if (secondaryButtonText != null)
                const SizedBox(
                  height: 5,
                ),
              if (secondaryButtonText != null)
                SizedBox(
                  width: double.infinity,
                  child: GenericButton(
                    text: secondaryButtonText,
                    onPressed: onPressedSecondary,
                    borderColor: Colors.white,
                    textColor: Colors.blue,
                    shadowColor: Colors.white,
                    elevation: 0,
                    backgroundColor: AppColors.white,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
