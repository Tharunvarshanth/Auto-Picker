import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes.dart';

class MenuMorePage extends StatefulWidget {
  const MenuMorePage({Key key}) : super(key: key);

  @override
  _MenuMoreState createState() => _MenuMoreState();
}

class _MenuMoreState extends State<MenuMorePage> {
  final FirebaseAuth existingUser = FirebaseAuth.instance;
  bool isLogged = false;
  var userInfo = UserInfoCache();

  void initState() {
    super.initState();
    print("Auth ${existingUser.currentUser}");
    setState(() {
      isLogged = existingUser.currentUser != null ? true : false;
    });
  }

  signOut() {
    //redirect
    userInfo.clearValue();
    existingUser
        .signOut()
        .then((value) => navigate(context, RouteGenerator.homePage));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Menu More',
        isLogged: isLogged,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: isLogged,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (isLogged) ...[
              getTile("Personal Controller",
                  () => {navigate(context, RouteGenerator.profilePage)}),
              getTile("Find Mechanics Nearby", () {}),
              getTile("Service Records", () {}),
              getTile("Fuel Manager", () {}),
              getTile("Notifications", () {}),
              getTile("My Orders", () {}),
            ],
            getTile("Mileage Calculator", () {}),
            getTile("Vehicle Information", () {}),
            getTile("Contact Us", () {}),
            getTile("About Us", () {}, borderColor: Colors.transparent),
            isLogged
                ? getTile("Logout", () => {signOut()},
                    textColor: AppColors.blue, borderColor: Colors.transparent)
                : getTile(
                    "Login",
                    () => {
                          Navigator.of(context)
                              ?.pushNamed(RouteGenerator.loginPage)
                        },
                    textColor: AppColors.blue,
                    borderColor: Colors.transparent)
          ],
        ),
      ),
    ));
  }
}

Widget getTile(String text, void Function() onPressed,
    {Color textColor = AppColors.black, Color borderColor = Colors.grey}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(
            text,
            style: TextStyle(fontSize: 18, color: textColor),
          )),
          IconButton(
            icon: SvgPicture.asset('assets/images/chevron-right.svg'),
            onPressed: onPressed,
            color: Colors.cyan,
          )
        ],
      ),
    ),
  );
}
