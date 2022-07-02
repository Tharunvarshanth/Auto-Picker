import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      await userController.updateUserField(
          existingUser.uid, 'email', existing.email);

      var user = await userController.getUser((existingUser.uid));
      userInfo.saveUser(true, existingUser.uid, existing.phoneNumber,
          existing.email, user['role']);
      navigate(context, RouteGenerator.homePage);
    } else {
      //error popup
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Sign With Email Failed',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context),
              ));
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
    var user = await userController.getUser((existingUser.uid));
    await userInfo.saveUser(true, existingUser.uid, existingUser.phoneNumber,
        existingUser.email, user['role']);
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      iconLeft: 'assets/images/at-sign.svg',
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
                  iconLeft: 'assets/images/at-sign.svg',
                ),
              ),
      ]),
    ));
  }
}
