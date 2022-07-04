import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
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
    return CurvedNavigationBar(
      items: [
        const Icon(Icons.home, size: 30, color: AppColors.white),
        if (isLogged)
          const Icon(
            Icons.notifications_active_outlined,
            size: 30,
            color: AppColors.white,
          ),
        if (isLogged)
          const Icon(Icons.supervised_user_circle_outlined,
              size: 30, color: AppColors.white),
        const Icon(Icons.menu_rounded, size: 30, color: AppColors.white),
      ],
      onTap: (value) {
        onTap == null ? onTapDefault(value, context) : onTap(value);
      },
      buttonBackgroundColor: AppColors.themePrimary,
      index: currentIndex == -1 ? 0 : currentIndex,
      height: 60.0,
      color: AppColors.themePrimary,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      backgroundColor: Colors.white,
      letIndexChange: (index) => true,
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
