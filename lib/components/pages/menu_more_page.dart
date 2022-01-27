import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuMorePage extends StatefulWidget {
  const MenuMorePage({Key key}) : super(key: key);

  @override
  _MenuMoreState createState() => _MenuMoreState();
}

class _MenuMoreState extends State<MenuMorePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Menu More',
        isLogged: true,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            getTile("Personal Controller", () {}),
            getTile("Find Mechanics Nearby", () {}),
            getTile("Find Spare Parts", () {}),
            getTile("Service Records", () {}),
            getTile("Fuel Manager", () {}),
            getTile("Mileage Calculator", () {}),
            getTile("Vehicle Information", () {}),
            getTile("Notifications", () {}),
            getTile("My Orders", () {}),
            getTile("Contact Us", () {}),
            getTile("About Us", () {}, borderColor: Colors.transparent),
            getTile("Login", () {},
                textColor: Colors.cyan, borderColor: Colors.transparent),
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
