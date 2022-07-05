import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  String location;
  String openHours;
  String miniTitle;
  String miniSubTitle;
  String buttonTitle;
  double titleSize;
  double subTitleSize;
  double padding;
  void Function() buttonPressed;
  void Function() locationPressed;
  ServiceCard(
      {Key key,
      this.buttonTitle = 'BUTTON TITLE',
      this.location = 'No Location',
      this.openHours = 'Open Hours',
      this.subTitleSize = 16,
      this.padding = 20,
      this.miniSubTitle = 'No Mini Sub Title',
      this.miniTitle = 'No Mini Title',
      this.buttonPressed,
      this.locationPressed,
      this.titleSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
        width: constraints.maxWidth * 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GenericText(
                          text: miniTitle,
                          textAlign: TextAlign.start,
                          textSize: titleSize ?? 16,
                        ),
                        GenericText(
                          text: miniSubTitle,
                          textAlign: TextAlign.start,
                          textSize: subTitleSize ?? 14,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    GenericButton(
                      isBold: true,
                      text: buttonTitle,
                      textColor: AppColors.primaryVariant,
                      onPressed: buttonPressed,
                      borderColor: AppColors.primaryVariant,
                      backgroundColor: AppColors.skyBlue,
                      paddingVertical: 5,
                      elevation: 0,
                    )
                  ],
                ),
                const Divider(
                  color: Colors.black45,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Location -',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: titleSize),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    TextButton(
                        onPressed: locationPressed,
                        child:
                            GenericText(text: location, textSize: subTitleSize))
                  ],
                ),
                const Divider(
                  color: Colors.black45,
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Working Hours -',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: titleSize),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Text(
                      openHours,
                      style: TextStyle(fontSize: subTitleSize),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
