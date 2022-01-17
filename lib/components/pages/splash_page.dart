import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_picker/routes.dart';

class SplashScreen extends StatelessWidget {
  var userInfo = new UserInfoCache();

  @override
  Widget build(BuildContext context) {
    Future<void> getLogged() async {
      if (await userInfo.getId() != null) {
        navigateWithState(
            context, RouteGenerator.homePage, await userInfo.getUser());
      } else {
        navigate(context, RouteGenerator.homePage);
      }
    }

    getLogged();

    return Scaffold(
      body: Center(
        child: Text('SplashScreen'),
      ),
    );
  }
}
