import 'dart:io';

import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  String title;

  String dateTime;
  String description;
  String notificationImgUrl;
  bool read;

  NotificationTile(
      {Key key,
      this.dateTime,
      this.description,
      this.notificationImgUrl,
      this.read,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: read ? Colors.grey : Colors.cyan,
      elevation: 8,
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              foregroundColor: AppColors.white,
              backgroundImage: AssetImage(notificationImgUrl),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(dateTime)
                          .toString(),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
