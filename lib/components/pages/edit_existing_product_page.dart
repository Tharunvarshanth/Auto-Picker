import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/product_add_edit_form.dart';
import 'package:auto_picker/models/product.dart';
import 'package:flutter/material.dart';

class EditExistingProductPage extends StatefulWidget {
  Product product;
  EditExistingProductPage({this.product});

  @override
  _EditExistingProductPageState createState() =>
      _EditExistingProductPageState();
}

class _EditExistingProductPageState extends State<EditExistingProductPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Product',
          isLogged: true,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 75, 10, 100),
            child: ProductAddEditForm(product: widget.product)));
  }
}
