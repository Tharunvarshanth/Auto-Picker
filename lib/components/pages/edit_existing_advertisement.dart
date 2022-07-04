import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/product_advertisment_add_edit_form.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:flutter/material.dart';

class EditExistingAdvertisementPage extends StatefulWidget {
  SpareAdvertisement spareAdvertisement;
  EditExistingAdvertisementPage({this.spareAdvertisement});

  @override
  _EditExistingAdvertisementPageState createState() =>
      _EditExistingAdvertisementPageState();
}

class _EditExistingAdvertisementPageState
    extends State<EditExistingAdvertisementPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Advertisement',
          isLogged: true,
          showBackButton: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 75, 10, 100),
            child: ProductAdvertisementAddForm(
                advertisement: widget.spareAdvertisement)));
  }
}
