import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/routes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  var userInfo = new UserInfoCache();

  @override
  Widget build(BuildContext context) {
    Future<void> getLogged() async {
      Future.delayed(const Duration(milliseconds: 1000), () async {
        if (await userInfo.getId() != null) {
          navigateWithState(
              context, RouteGenerator.homePage, await userInfo.getUser());
        } else {
          navigate(context, RouteGenerator.homePage);
        }
      });
    }

    getLogged();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(
                "assets/images/Auto-picker-jpg-project-icon.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SpinKitRipple(
          size: 125,
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            );
          },
        ) /* add child content here */,
      ),
    );
  }
}
