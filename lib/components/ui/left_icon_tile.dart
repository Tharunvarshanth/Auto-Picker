import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class LeftIconTile extends StatelessWidget {
  LeftIconTile({
    Key key,
    this.text,
    this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: AppColors.Blue,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.blue[100],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blue[500],
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
