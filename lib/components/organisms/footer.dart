import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../../routes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Footer extends StatefulWidget {
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
      this.currentIndex = -1,
      this.elevation = 0,
      this.iconColor = Colors.blue,
      this.iconSize = 20,
      this.isLogged = false,
      this.onTap,
      this.selectedItemColor = AppColors.black,
      this.unselectedItemColor = Colors.blue})
      : super(key: key);
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    isLogged = _auth?.currentUser != null ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryVariant,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GNav(
            backgroundColor: AppColors.primaryVariant,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.green,
            gap: 8,
            padding: EdgeInsets.all(8),
            rippleColor: AppColors.Blue,
            //Colors.grey[800], // tab button ripple color when pressed
            hoverColor: Colors.blue[700], // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            tabActiveBorder: Border.all(
                color: Colors.blue[400], width: 1), // tab button border
            tabBorder: Border.all(
                color: Colors.blue[600], width: 1), // tab button border
            tabShadow: [
              BoxShadow(color: Colors.blue[700].withOpacity(0.5), blurRadius: 8)
            ], // tab button shadow
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 900),
            iconSize: 24,
            selectedIndex: widget.currentIndex,
            onTabChange: (index) {
              widget.onTap == null
                  ? onTapDefault(index, context)
                  : widget.onTap(index);
            }, // navigation bar padding
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              if (isLogged)
                GButton(
                  icon: LineIcons.inbox,
                  text: 'Notification',
                ),
              if (isLogged)
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              GButton(
                icon: LineIcons.store,
                text: 'Menu',
              )
            ]),
      ),
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
