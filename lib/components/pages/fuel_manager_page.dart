import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FuelManagerPage extends StatefulWidget {
  const FuelManagerPage();

  @override
  _FuelManagerPageState createState() => _FuelManagerPageState();
}

class _FuelManagerPageState extends State<FuelManagerPage> {
  List<String> imageList = ["value 1", "value 2"];

  Widget build(BuildContext context) {
    //addProduct();

    return Scaffold(
        appBar: CustomAppBar(
          title: 'Fuel Cost Manager',
          isLogged: false,
          showBackButton: false,
        ),
        body: Center(child: Text('TestPage')));
  }
}
