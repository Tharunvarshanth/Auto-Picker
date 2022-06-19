import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class VehicleServiceRecord extends StatelessWidget {
  String title;
  String desciption;
  String notificationsDate;
  String date;

  void Function() buttonPressed;
  void Function() locationPressed;
  VehicleServiceRecord({
    Key key,
    this.title = '',
    this.desciption = '',
    this.notificationsDate = '',
    this.date = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth * 1,
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
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
                            text: title,
                            textAlign: TextAlign.start,
                            textSize: 16,
                          ),
                          GenericText(
                            text: "Mileage : ${desciption}",
                            textAlign: TextAlign.start,
                            textSize: 14,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
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
                            'Serviced Date - ${date}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
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
                            'Next Service Date - ${notificationsDate}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
