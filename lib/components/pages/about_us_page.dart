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
          isLogged: false,
          showBackButton: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GenericText(
              text: 'About us',
            ),
            GenericText(
              text: 'Contact us Our Team',
            ),
            GenericText(
              text: 'App Version 1.0.0',
            ),
          ],
        ));
  }
}
