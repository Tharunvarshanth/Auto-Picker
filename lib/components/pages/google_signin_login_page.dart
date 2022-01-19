import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLinkingPage extends StatefulWidget {
  final bool isLinkingPage;
  const GoogleLinkingPage({this.isLinkingPage});

  @override
  _GoogleLinkingPageState createState() => _GoogleLinkingPageState();
}

class _GoogleLinkingPageState extends State<GoogleLinkingPage> {
  bool isLinkingPage = false;
  var userInfo = UserInfoCache();
  var userController = UserController();
  void initState() {
    super.initState();
    setState(() {
      isLinkingPage = widget.isLinkingPage;
    });
  }

  linkEmailGoogle() async {
    //get currently logged in user
    var existingUser = FirebaseAuth.instance.currentUser;

    //get the credentials of the new linking account
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
// Create a new credential
    final AuthCredential gcredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //now link these credentials with the existing user
    var linkauthresult = await existingUser.linkWithCredential(gcredential);

    if (linkauthresult != null) {
      var existing = FirebaseAuth.instance.currentUser;
      print("existingUser ${existing.phoneNumber}  ${existing.email}  ");
      userInfo.saveUser(
          true, existingUser.uid, existing.phoneNumber, existing.email);
      navigate(context, RouteGenerator.homePage);
    } else {
      //error popup
    }
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCred = await FirebaseAuth.instance.signInWithCredential(credential);
    var existingUser = FirebaseAuth.instance.currentUser;
    print("existingUser ${existingUser.phoneNumber}  ${existingUser.email}  ");
    await userInfo.saveUser(
        true, existingUser.uid, existingUser.phoneNumber, existingUser.email);
    if (userCred != null) {
      navigate(context, RouteGenerator.homePage);
    } else {
      //error popup
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        isLinkingPage
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    GenericText(
                      text: 'Email Linking',
                      isBold: true,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GenericText(
                      text:
                          'Link your google account with your mobile number incase if you have not sim in your device you can login with your google account',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GenericIconButton(
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      shadowColor: AppColors.ash,
                      text: 'Link with Google Account',
                      onPressed: () => linkEmailGoogle(),
                    ),
                  ],
                ),
              )
            : Center(
                child: GenericIconButton(
                  backgroundColor: AppColors.white,
                  textColor: AppColors.black,
                  shadowColor: AppColors.ash,
                  text: 'Login with Account',
                  onPressed: () => signInWithGoogle(),
                  iconLeft: Icon(Icons.email),
                ),
              ),
      ]),
    ));
  }
}
