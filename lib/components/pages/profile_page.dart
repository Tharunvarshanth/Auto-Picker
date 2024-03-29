import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/details_card_description.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/text_description.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/mechanic_profile.dart';
import 'package:auto_picker/components/organisms/seller_profile.dart';
import 'package:auto_picker/components/pages/profile_user_edit_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileUrl;

  FirebaseAuth existingUser;
  UserModel userModel;
  Mechanic mechanicModel;
  Seller sellerModel;
  bool isLoading = true;
  String userRole;
  var userController = UserController();
  var mechanicsController = MechanicController();
  var sellerController = SellerController();
  var userInfo = UserInfoCache();

  @override
  void initState() {
    super.initState();
    existingUser = FirebaseAuth.instance;
    profileUrl = existingUser.currentUser.photoURL;
    getUserInfo();
  }

  void getUserInfo() async {
    var _user = await userController.getUser((existingUser.currentUser.uid));

    setState(() {
      userRole = _user["role"];
    });
    switch (userRole) {
      case Users.Mechanic:
        {
          var _m = await mechanicsController
              .getMechanic((existingUser.currentUser.uid));
          mechanicModel = Mechanic.fromJson(_m);
          print("user smechanics ${_m}");
        }

        break;
      case Users.Seller:
        {
          var _s =
              await sellerController.getSeller((existingUser.currentUser.uid));
          sellerModel = Seller.fromJson(_s);
          print("user seller ${_s}");
        }
        break;
    }
    userModel = UserModel.fromJson(_user);
    setState(() {
      isLoading = false;
    });
    print("user ${userModel.role}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Profile Controller',
          showBackButton: true,
        ),
        bottomNavigationBar: Footer(
          isLogged: true,
          currentIndex: 2,
        ),
        body: SingleChildScrollView(
          child: isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  ))
              : Container(
                  padding: EdgeInsets.fromLTRB(7.5, 20, 7.5, 10),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProfileAvatar(
                            profileUrl ?? '',
                            initialsText: Text(
                              userModel.fullName[0],
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            radius: 40,
                            imageFit: BoxFit.fitHeight,
                            placeHolder: (context, url) => Container(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(),
                            ),
                            backgroundColor: AppColors.themePrimary,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericText(
                                  text: userModel.fullName,
                                  isBold: true,
                                  textSize: 24,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GenericTextButton(
                                  text: 'Edit Profile',
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileUserEditPage(
                                                  userModel: userModel,
                                                  mechanic: mechanicModel,
                                                  seller: sellerModel),
                                        ))
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      DetailsCardDescription(
                          title: userModel.role, description: 'Role'),
                      DetailsCardDescription(
                        title: userModel.phoneNumber,
                        description: 'Mobile Number',
                      ),
                      if (userModel.email != '')
                        DetailsCardDescription(
                          title: userModel.email,
                          description: 'Email',
                        ),
                      DetailsCardDescription(
                        title: userModel.city,
                        description: 'City',
                      ),
                      DetailsCardDescription(
                        title: userModel.address,
                        description: 'Address',
                      ),
                      if (userRole == Users.Seller)
                        SizedBox(height: size.height * 0.015),
                      if (userRole == Users.Seller) SellerProfile(sellerModel),
                      if (userRole == Users.Mechanic)
                        MechanicProfile(mechanicModel)
                    ],
                  ),
                ),
        ));
  }
}
