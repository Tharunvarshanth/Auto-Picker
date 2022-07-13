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
      this.padding = 0,
      this.onPress,
      this.url = "assets/images/chevron-right-blue.svg",
      this.borderColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Card(
        shadowColor: AppColors.themePrimary,
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            //color: Colors.blue[100]
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 168, 203, 255),
                Color.fromARGB(255, 168, 203, 255)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          fontSize: 17,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
        ),
      ),
    );
  }
}
