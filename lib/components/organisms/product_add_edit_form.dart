import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';

class ProductAddEditForm extends StatefulWidget {
  final Map<String, dynamic> params;
  const ProductAddEditForm({Map<String, dynamic> this.params});
  @override
  _ProductAddEditFormState createState() => _ProductAddEditFormState();
}

class _ProductAddEditFormState extends State<ProductAddEditForm> {
  FirebaseAuth existingUser = FirebaseAuth.instance;
  final productTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final conditionToController = TextEditingController();
  String condition;
  List<String> imageList;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';
  var productController = ProductController();

  void initState() {
    super.initState();
  }

  void handleConditionChange(_condition) {
    setState(() {
      condition = _condition;
    });
  }

  void handleAdd() async {
    /*  widget.params['price'] = priceController.text;
    widget.params['title'] = productTitleController.text;
    widget.params['description'] = descriptionController.text;
    widget.params['condition'] = condition;
    widget.params['imageList'] = imageList;*/
    var product = Product(
        existingUser.currentUser.uid,
        priceController.text,
        productTitleController.text,
        descriptionController.text,
        condition,
        imageList);
    var res = await productController.addProduct(product);
    if (res != null) {
      print("recent $res");
      List<String> imageList = await uploadFiles(images, res);
      print("imageList ${imageList}");
      if (await productController.updateProduct(
          existingUser.currentUser.uid, res, imageList)) {
      } else {
        //errpopup
      }
    } else {
      //error popup
    }
  }

  @override
  void dispose() {
    priceController.dispose();
    productTitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future<List<String>> uploadFiles(List<Asset> _images, String pid) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image, pid)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(Asset _image, String pid) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${existingUser.currentUser.uid}/products/$pid/${_image.name}');

    return ((await ref.putFile(await getImageFileFromAssets(_image)))
        .ref
        .fullPath);
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Auto Picker",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            GenericTextField(
              controller: productTitleController,
              labelText: 'Product Title',
              hintText: "Front Bumper",
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: descriptionController,
              labelText: 'Description',
              hintText: "Panel -40000, Shell -25000 ,Lower Mesh -20000",
              borderColor: AppColors.ash,
            ),
            GenericTextField(
              controller: priceController,
              labelText: 'Price(rs)',
              hintText: "400.00 Rs",
              borderColor: AppColors.ash,
            ),
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'Condition',
              value: condition,
              itemList: SPAREPARTSCONDITIONLIST,
              onValueChange: (text) => handleConditionChange(text),
            ),
            SizedBox(height: size.height * 0.025),
            GenericIconButton(
              backgroundColor: AppColors.white,
              textColor: AppColors.black,
              shadowColor: AppColors.ash,
              text: 'Upload Images',
              borderRadius: 30,
              onPressed: loadAssets,
              iconLeft: 'assets/images/camera.svg',
            ),
            SizedBox(height: size.height * 0.015),
            SizedBox(
                height: images.length == 0 ? 0 : 100, child: buildGridView()),
            SizedBox(height: size.height * 0.015),
            GenericButton(
              textColor: AppColors.white,
              backgroundColor: AppColors.Blue,
              paddingVertical: 20,
              paddingHorizontal: 80,
              text: 'Add',
              onPressed: () {
                //validations ok
                handleAdd();
              },
              isBold: true,
            ),
          ],
        ));
  }
}
