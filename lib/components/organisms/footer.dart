import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

import '../../routes.dart';

class Footer extends StatelessWidget {
  Color backgroundColor;
  Color iconColor;
  void Function(int index) onTap;
  int currentIndex;
  double elevation;
  bool isLogged;
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
      this.isLogged = false,
      this.onTap,
      this.selectedItemColor = AppColors.black,
      this.unselectedItemColor = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/home.svg'),
          label: 'Home',
          activeIcon: SvgPicture.asset('assets/images/home-active.svg'),
        ),
        if (isLogged)
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/bell.svg'),
              label: 'Notifications',
              activeIcon: SvgPicture.asset('assets/images/bell-active.svg')),
        if (isLogged)
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/user.svg'),
            activeIcon: SvgPicture.asset('assets/images/user-active.svg'),
            label: 'Profile',
          ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/menu.svg'),
          activeIcon: SvgPicture.asset('assets/images/menu-active.svg'),
          label: 'Menu',
        ),
      ],
      onTap: (value) => {
        onTap == null ? onTapDefault(value, context) : onTap(value),
      },
      currentIndex: currentIndex,
      backgroundColor: backgroundColor,
      elevation: elevation,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    );
  }

  void onTapDefault(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          navigate(context, RouteGenerator.homePage);
        }
        break;
      case 1:
        {
          isLogged
              ? navigate(context, RouteGenerator.notificationsPage)
              : navigate(context, RouteGenerator.menuMorePage);
        }
        break;
      case 2:
        {
          isLogged
              ? navigate(context, RouteGenerator.profilePage)
              : navigate(context, RouteGenerator.menuMorePage);
        }
        break;
      case 3:
        {
          navigate(context, RouteGenerator.menuMorePage);
        }
        break;
    }
  }
}
