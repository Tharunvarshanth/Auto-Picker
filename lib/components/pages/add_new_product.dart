import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/product_add_edit_form.dart';
import 'package:flutter/material.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage();

  @override
  _AddNewProductPageState createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: 'Add Product',
          isLogged: true,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
            child: ProductAddEditForm()));
  }
}
