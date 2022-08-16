import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/user_payment_page.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../routes.dart';
import 'google_signin_login_page.dart';

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
    //usually called after the user logs out of your app
    OneSignal.shared.removeExternalUserId();
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
        currentIndex: isLogged ? 3 : 1,
        isLogged: isLogged,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (isLogged) ...[
              getTile("Personal Controller",
                  () => {navigate(context, RouteGenerator.profilePage)},
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("Find Mechanics Nearby", () {
                navigate(context, RouteGenerator.findNearByMechanicsPage);
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("Vehicle Service Records Maintainence", () {
                navigate(
                    context, RouteGenerator.vehicleServiceMaintainancePage);
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("Mechanics", () {
                navigate(context, RouteGenerator.mechanicsListingPage);
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("Products", () {
                navigate(context, RouteGenerator.productsListingPage);
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("My Orders", () {
                navigate(context, RouteGenerator.myOrdersPage);
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
              getTile("Link Google Account", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoogleLinkingPage(
                      isLinkingPage: true,
                    ),
                  ),
                );
              },
                  borderColor: Color.fromARGB(255, 44, 124, 243),
                  insideColor: Color.fromARGB(255, 168, 203, 255)),
            ],
            /*  getTile("Mileage Calculator", () {}),*/
            /*   getTile("Vehicle Information", () {}),*/
            getTile("Fuel Alert Chat", () {
              navigate(context, RouteGenerator.fuelAlertPage);
            },
                borderColor: Color.fromARGB(255, 44, 124, 243),
                insideColor: Color.fromARGB(255, 168, 203, 255)),
            getTile("About Us", () {
              navigate(context, RouteGenerator.aboutUsPage);
            },
                borderColor: Color.fromARGB(255, 44, 124, 243),
                insideColor: Color.fromARGB(255, 168, 203, 255)),
            isLogged
                ? getTile("Logout", () => {signOut()},
                    textColor: Color.fromARGB(199, 0, 0, 0),
                    borderColor: Color.fromARGB(255, 255, 0, 0),
                    insideColor: Color.fromARGB(255, 255, 147, 147))
                : getTile(
                    "Login",
                    () => {
                          Navigator.of(context)
                              ?.pushNamed(RouteGenerator.loginPage)
                        },
                    textColor: AppColors.blue,
                    borderColor: Color.fromARGB(255, 0, 155, 8),
                    insideColor: Color.fromARGB(255, 96, 253, 104))
          ],
        ),
      ),
    ));
  }
}

Widget getTile(String text, void Function() onPressed,
    {Color textColor = AppColors.black,
    Color borderColor = Colors.grey,
    Color insideColor = Colors.grey}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: const [
        //     Color.fromARGB(255, 255, 255, 255),
        //     Color.fromARGB(255, 168, 203, 255)
        //   ],
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        // ),
        color: insideColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          Expanded(
              child: Text(
            text,
            style: TextStyle(
                fontSize: 18, color: textColor, fontWeight: FontWeight.w600),
          )),
        ],
      ),
    ),
  );
}
