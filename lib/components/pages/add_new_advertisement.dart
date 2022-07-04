import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/product_advertisment_add_edit_form.dart';
import 'package:flutter/material.dart';

class AddNewAdvertisementPage extends StatefulWidget {
  const AddNewAdvertisementPage();

  @override
  _AddNewAdvertisementPageState createState() =>
      _AddNewAdvertisementPageState();
}

class _AddNewAdvertisementPageState extends State<AddNewAdvertisementPage> {
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: 'Add Advertisement',
          isLogged: true,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 25, 10, 100),
            child: ProductAdvertisementAddForm()));
  }
}
