import 'package:auto_picker/components/organisms/footer.dart';
import 'package:flutter/material.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({Key key}) : super(key: key);

  @override
  _MoreMenuState createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Menu More'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  size: 26.0,
                ),
              )),
        ],
        actionsIconTheme:
            IconThemeData(size: 30.0, color: Colors.grey, opacity: 10.0),
      ),
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            getTile("Personal Info", () {}),
            getTile("Find Mechanics", () {}),
            getTile("Find Spare Parts", () {}),
            getTile("Service Records", () {}),
            getTile("Fuel Manager", () {}),
            getTile("Mileage Calculator", () {}),
            getTile("Find Near by Garage", () {}),
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
    {Color textColor = Colors.black, Color borderColor = Colors.grey}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(
            text,
            style: TextStyle(fontSize: 20, color: textColor),
          )),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: onPressed,
            color: Colors.cyan,
          )
        ],
      ),
    ),
  );
}
