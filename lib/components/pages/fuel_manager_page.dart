import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage();

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> imageList = ["value 1", "value 2"];
  var _productController = ProductController();

  void addProduct() async {
    var testDate = {
      "uid": "user-01",
      "price": "12.22",
      "description": "des",
      "title": "title",
      "subtitle": "subtitle",
      "city": "city",
      "condition": "condition",
      "imagesList": imageList
    };
    Product product = Product.fromJson(testDate);
    var res = await _productController.addProduct(product);
  }

  void getProduct() async {
    var res =
        await _productController.getProduct("user-01", "9LBVGRH7GkeAqi1K4tot");
    print("Products $res");
  }

  Widget build(BuildContext context) {
    //addProduct();
    getProduct();
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Fuel Cost Manager',
          isLogged: false,
          showBackButton: false,
        ),
        body: Center(child: Text('TestPage')));
  }
}
