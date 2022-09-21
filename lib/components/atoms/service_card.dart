import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/ui/backgroud.dart';
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
        margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
        width: constraints.maxWidth * 1,
        child: Card(
          color: Color.fromARGB(255, 14, 71, 161),
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
                          color: Colors.white,
                          text: miniTitle,
                          textAlign: TextAlign.start,
                          textSize: titleSize ?? 16,
                        ),
                        GenericText(
                          color: Colors.white,
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
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      paddingVertical: 5,
                      elevation: 0,
                    )
                  ],
                ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: locationPressed,
                            child: GenericText(
                              text: location,
                              textSize: subTitleSize,
                              color: Colors.white,
                            ))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Text(
                      openHours,
                      style: TextStyle(
                        fontSize: subTitleSize,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        // decoration: new BoxDecoration(
        //   boxShadow: [
        //     new BoxShadow(
        //       color: Color.fromARGB(255, 165, 165, 165),
        //       blurRadius: 0,
        //     ),
        //   ],
        // ),
      );
    });
  }
}
