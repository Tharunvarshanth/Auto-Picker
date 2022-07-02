import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/ui/backgroud.dart';
import 'package:auto_picker/routes.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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

  //first time sign up
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
                titleText: 'Linking With Email Failed',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context),
              ));
    }
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser =
        await GoogleSignIn().signIn().catchError((onError) => print(onError));
    ;
// Return null to prevent further exceptions if googleSignInAccount is null
    if (googleUser == null) return null;

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
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Sign In With Email Failed',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context),
              ));
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        isLinkingPage
            ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello There!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        'assets/images/google_patches.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: Text(
                        "Link your google account with your mobile number incase if you have not sim in your device you can login with your google account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Container(
                            width: 250,
                            height: 50,
                            child: SignInButton(
                              Buttons.Google,
                              mini: true,
                              text: "Sign up with Google",
                              onPressed: () => linkEmailGoogle(),
                            )),
                      ),
                    )
                  ],
                )
              ])
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    IconButton(
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                      iconSize: 40,
                      alignment: Alignment.topLeft,
                      icon: Image.asset(
                        "assets/images/back-arrow.png",
                        scale: 1.2,
                      ),
                      onPressed: () {
                        navigateBack(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        'assets/images/google_patches.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Sign In With Google Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Container(
                          width: 250,
                          height: 50,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Login with Account",
                            onPressed: () => signInWithGoogle(),
                          ),
                        ),
                      ),
                    )
                  ]),
      ]),
    ));
  }
}
