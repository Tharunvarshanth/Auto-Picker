import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage();

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  void initState() {}

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'About Us',
          isLogged: true,
          showBackButton: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              GenericText(
                isBold: true,
                text: 'About us',
              ),
              GenericText(
                text:
                    'A mobile application called “Auto Picker” helps people who have vehicles, at the same time those who import and export vehicle spare parts, modification parts, and mechanics will get some benefits.',
              ),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              GenericText(
                text: 'Contact us Our Team',
              ),
              GenericText(
                text: 'Contact : 076 8407950',
              ),
              GenericText(
                text: 'Email : tharunvar10@gmail.com',
              ),
            ]),
            GenericText(
              text: 'App Version 1.0.0',
            ),
          ],
        ));
  }
}
