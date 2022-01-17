import 'package:flutter/material.dart';

class ServiceTile extends StatelessWidget {
  String title;
  String subTitle;
  Icon iconLeft;
  Icon iconRight;

  double titleTextSize;
  double subtitleTextSize;
  void Function() onPressed;
  ServiceTile(
      {Key key,
      this.iconLeft,
      this.iconRight,
      this.onPressed,
      this.subTitle = 'sub title',
      this.title = 'title',
      this.subtitleTextSize = 24,
      this.titleTextSize = 32})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: iconLeft,
          flex: 2,
        ),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: titleTextSize,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: subtitleTextSize,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: onPressed,
            icon: iconRight,
          ),
          flex: 2,
        )
      ],
    );
  }
}
