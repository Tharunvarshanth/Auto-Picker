import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class DetailsCardDescription extends StatelessWidget {
  String title;
  String description;
  void Function() onPress;

  DetailsCardDescription({
    Key key,
    this.title,
    this.description = "",
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        shadowColor: AppColors.themePrimary,
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            //color: Colors.blue[100]
            gradient: LinearGradient(
              colors: const [
                Color.fromARGB(255, 168, 203, 255),
                Color.fromARGB(255, 168, 203, 255)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description != "") const SizedBox(height: 4),
              if (description != "")
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black45,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
