import 'package:auto_picker/components/atoms/generic_button.dart';
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
        width: constraints.maxWidth * 1,
        child: SingleChildScrollView(
          child: Card(
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
                          Text(
                            miniTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: titleSize),
                          ),
                          Text(
                            miniSubTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: subTitleSize),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      GenericButton(
                        text: buttonTitle,
                        onPressed: buttonPressed,
                        borderColor: Colors.blue,
                        backgroundColor: Colors.cyan[50],
                        paddingVertical: 5,
                        shadowColor: Colors.transparent,
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
                            'Location',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: titleSize),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      TextButton(
                          onPressed: locationPressed,
                          child: Text(
                            location,
                            style: TextStyle(
                                fontSize: subTitleSize,
                                decoration: TextDecoration.underline),
                          ))
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
                            'Working Hours',
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
        ),
      );
    });
  }
}
