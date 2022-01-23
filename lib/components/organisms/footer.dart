import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  Color backgroundColor;
  Color iconColor;
  void Function(int index) onTap;
  List<IconLabelPair> items;
  int currentIndex;
  double elevation;

  double iconSize;
  Color selectedItemColor;
  Color unselectedItemColor;
  Footer(
      {Key key,
      this.backgroundColor = Colors.white,
      this.currentIndex = 0,
      this.elevation = 0,
      this.iconColor = Colors.blue,
      this.iconSize = 20,
      this.items,
      this.onTap,
      this.selectedItemColor = Colors.lightGreen,
      this.unselectedItemColor = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items
          .map((e) => BottomNavigationBarItem(
                icon: e.icon,
                label: e.label,
              ))
          .toList(),
      onTap: onTap,
      currentIndex: currentIndex,
      backgroundColor: backgroundColor,
      elevation: elevation,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    );
  }
}

class IconLabelPair {
  Icon icon;
  String label;
  IconLabelPair({this.icon, this.label});
}
