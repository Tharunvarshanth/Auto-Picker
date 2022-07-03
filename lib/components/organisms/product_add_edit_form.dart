import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/product_payment_page.dart';
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
  final Product product;
  const ProductAddEditForm({this.product});

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
  bool isButtonDisabled = true;
  var productController = ProductController();

  void initState() {
    super.initState();
    if (widget.product != null) {
      productTitleController.text = widget.product.title;
      descriptionController.text = widget.product.description;
      priceController.text = widget.product.price;
      conditionToController.text = widget.product.condition;
      setState(() {
        condition = widget.product.condition;
      });
    }
  }

  void handleConditionChange(_condition) {
    setState(() {
      condition = _condition;
    });
  }

  adEndDate() {
    return (DateTime.now().add(const Duration(days: 30)));
  }

  void handleAdd() async {
    var product = Product(
        existingUser.currentUser.uid,
        priceController.text,
        productTitleController.text,
        descriptionController.text,
        condition,
        imageList,
        '',
        false,
        adEndDate().toString());
    var res = await productController.addProduct(product);
    if (res != null) {
      var pRes = await productController.updateProduct(
          existingUser.currentUser.uid, res, 'pId', res);
      print("recent $res");
      List<String> imageList = await uploadFiles(images, res);
      print("imageList ${imageList}");
      if (await productController.updateProduct(
          existingUser.currentUser.uid, res, 'imagesList', imageList)) {
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Success',
                bodyText:
                    "Prdouct successfully added Please Pay amount then your product go will go live",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPaymentPage(
                        productId: res,
                      ),
                    ))));
      } else {
        //errpopup
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/x-circle.svg',
                  titleText: 'Failure',
                  bodyText: "Prdouct  image upload getting failed try again",
                  primaryButtonText: 'Ok',
                  onPressedPrimary: () =>
                      navigate(context, RouteGenerator.homePage),
                ));
      }
    } else {
      //error popup
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Failure',
                bodyText: "Prdouct  adding failed try again",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.homePage),
              ));
    }
  }

  void fillRequiredFields() {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: 'Fill All Required Fields',
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  void handleUpdate() async {
    var product = Product(
        existingUser.currentUser.uid,
        priceController.text,
        productTitleController.text,
        descriptionController.text,
        condition,
        widget.product.imagesList,
        widget.product.pId,
        widget.product.isPayed,
        widget.product.deletingDate);
    var res = await productController.updateProductAllField(product);
    if (res) {
      //popup
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Done ok',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.homePage),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Failure',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.homePage),
              ));
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

  Future<String> downloadURL(String url) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(url)
        .getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadFile(Asset _image, String pid) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${existingUser.currentUser.uid}/products/$pid/${_image.name}');
    String url = ((await ref.putFile(await getImageFileFromAssets(_image)))
        .ref
        .fullPath);

    return downloadURL(url);
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

  setButtonStatus() {
    if (productTitleController.text.isEmpty) {
      setState(() {
        isButtonDisabled = true;
      });
      return;
    }
    setState(() {
      isButtonDisabled = false;
    });
    return;
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
            GenericText(
              textAlign: TextAlign.left,
              text: 'Required *',
              color: AppColors.red,
              isBold: true,
            ),
            GenericTextField(
              controller: productTitleController,
              labelText: 'Product Title *',
              hintText: "Front Bumper",
              borderColor: AppColors.ash,
            ),
            SizedBox(height: size.height * 0.015),
            GenericTextField(
              controller: descriptionController,
              labelText: 'Description *',
              hintText: "Panel -40000, Shell -25000 ,Lower Mesh -20000",
              borderColor: AppColors.ash,
            ),
            GenericTextField(
              controller: priceController,
              labelText: 'Price(rs) *',
              hintText: "400.00 Rs",
              borderColor: AppColors.ash,
            ),
            GenericInputOptionSelect(
              width: size.width,
              labelText: 'Condition *',
              value: condition,
              itemList: SPAREPARTSCONDITIONLIST,
              onValueChange: (text) => handleConditionChange(text),
            ),
            SizedBox(height: size.height * 0.025),
            if (widget.product == null)
              GenericIconButton(
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                shadowColor: AppColors.ash,
                text: 'Upload Images *',
                borderRadius: 30,
                onPressed: loadAssets,
                iconLeft: 'assets/images/camera.svg',
              ),
            SizedBox(height: size.height * 0.015),
            SizedBox(
                height: images.length == 0 ? 0 : 100, child: buildGridView()),
            SizedBox(height: size.height * 0.015),
            widget.product == null
                ? GenericButton(
                    textColor: AppColors.white,
                    backgroundColor: AppColors.Blue,
                    paddingVertical: 20,
                    paddingHorizontal: 80,
                    text: 'Add',
                    onPressed: () {
                      if (productTitleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          condition.toString().isEmpty ||
                          images.length == 0) {
                        fillRequiredFields();
                        return;
                      }
                      //validations ok
                      handleAdd();
                    },
                    isBold: true,
                  )
                : GenericButton(
                    // isDisabled: isButtonDisabled,
                    textColor: AppColors.white,
                    backgroundColor: AppColors.Blue,
                    paddingVertical: 20,
                    paddingHorizontal: 80,
                    text: 'Update',
                    onPressed: () {
                      if (productTitleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          condition.toString().isEmpty ||
                          images.length == 0) {
                        fillRequiredFields();
                        return;
                      }
                      handleUpdate();
                    },
                    isBold: true,
                  ),
          ],
        ));
  }
}
