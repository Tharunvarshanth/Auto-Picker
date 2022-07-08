import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/ui/left_icon_tile.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage();

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    isLogged = _auth?.currentUser != null ? true : false;
  }

  Widget build(BuildContext context) {
    List<String> desc = [
      'A mobile application called “Auto Picker” helps people who have vehicles, at the same time those who import and export vehicle spare parts, modification parts, and mechanics will get some benefits.'
    ];
    return Scaffold(
        appBar: CustomAppBar(
          title: 'About Us',
          isLogged: isLogged,
          showBackButton: true,
        ),
        bottomNavigationBar: Footer(
          currentIndex: -1,
          isLogged: isLogged,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15, 25, 15, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: Image.asset(
                    "assets/images/information.png",
                    scale: 0.5,
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      BulletedList(
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                        listItems: desc,
                        listOrder: ListOrder.unordered,
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GenericText(
                              isBold: true,
                              textSize: 22,
                              text: 'Contact us',
                            ),
                          ],
                        ),
                        LeftIconTile(
                          icon: Icons.call_sharp,
                          text: '076 8407950',
                        ),
                        LeftIconTile(
                          icon: Icons.email,
                          text: 'tharunvar10@gmail.com',
                        ),
                      ]),
                ),
                Center(
                  child: GenericText(
                    color: AppColors.primaryVariant,
                    text: 'App Version 1.0.0',
                  ),
                )
              ],
            )));
  }
}
