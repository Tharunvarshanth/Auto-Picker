import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

SuperTooltip getToolTip({
  Color backgroundColor = Colors.indigo,
  Color textColor = Colors.white,
  String text = '',
  double textSize = 20,
  Color borderColor = Colors.white,
  Color closeButtonColor = Colors.white,
  bool showClose = true,
  Color iconColor = Colors.white,
  double iconSize = 32,
  IconData tipIconData,
}) {
  return SuperTooltip(
    borderColor: borderColor,
    showCloseButton: showClose ? ShowCloseButton.inside : ShowCloseButton.none,
    closeButtonColor: closeButtonColor,
    backgroundColor: backgroundColor,
    content: Material(
        color: backgroundColor,
        child: Row(children: [
          Icon(
            tipIconData,
            size: iconSize,
            color: iconColor,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ])),
    popupDirection: TooltipDirection.down,
  );
}
