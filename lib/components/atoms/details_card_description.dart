import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class DetailsCardDescription extends StatelessWidget {
  String title;
  String description;

  DetailsCardDescription({Key key, this.title, this.description = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.themePrimary,
      elevation: 2,
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (description != "") const SizedBox(height: 4),
            if (description != "")
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.themePrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
