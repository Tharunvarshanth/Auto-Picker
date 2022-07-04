import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextDescriptionWithButton extends StatelessWidget {
  String title;
  String description;
  double titleTextSize;
  double descriptionTextSize;
  double iconSize;
  Color titleColor;
  Color descriptionColor;
  Color iconColor;
  IconData icon;
  Color borderColor;
  double padding;
  String url;
  void Function() onPress;
  TextDescriptionWithButton(
      {Key key,
      this.description = 'No Description',
      this.descriptionColor = Colors.black45,
      this.descriptionTextSize,
      this.iconColor = Colors.black,
      this.iconSize,
      this.title = 'No Title',
      this.titleColor = Colors.black,
      this.titleTextSize,
      this.icon = Icons.arrow_right,
      this.padding = 10,
      this.onPress,
      this.url = "assets/images/chevron-right-blue.svg",
      this.borderColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: titleTextSize ?? 20, color: titleColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: descriptionTextSize ?? 16,
                        color: descriptionColor),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: onPress,
                icon: SvgPicture.asset(url),
                color: AppColors.blue,
                iconSize: 36,
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
