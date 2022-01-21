import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/pages/advertisement_payment_page.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/order_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInfo = new UserInfoCache();
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    print("Home Page Auth Current user: ${_auth.currentUser}");
  }

  signOut() {
    //redirect
    userInfo.clearValue();
    _auth.signOut().then((value) => navigate(context, RouteGenerator.homePage));
  }

  testFunction() {
    navigate(context, RouteGenerator.mapLatLonGetter);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getLogged() async {
      if (await userInfo.getId() != null) {
        setState(() {
          isLogged = true;
        });
      }
    }

    getLogged();

    return Scaffold(
        appBar: CustomAppBar(
          title: 'Home',
          isLogged: isLogged,
          showBackButton: false,
        ),
        body: Column(children: [
          GenericButton(
            text: 'Logout',
            onPressed: () => signOut(),
          ),
          GenericButton(
            text: 'Profile',
            onPressed: () => navigate(context, RouteGenerator.profilePage),
          ),
          GenericButton(
            text: 'Payment',
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdvertisementPaymentPage(
                      params: {'adId': '728vjzix16tEfYpBZNNQ'}),
                ),
              )
            },
          ),
        ]));
  }
}
