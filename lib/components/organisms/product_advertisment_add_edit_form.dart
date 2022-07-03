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
import 'package:auto_picker/components/pages/advertisement_payment_page.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
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

class ProductAdvertisementAddForm extends StatefulWidget {
  final SpareAdvertisement advertisement;
  const ProductAdvertisementAddForm({this.advertisement});
  @override
  _ProductAdvertisementAddFormState createState() =>
      _ProductAdvertisementAddFormState();
}

class _ProductAdvertisementAddFormState
    extends State<ProductAdvertisementAddForm> {
  FirebaseAuth existingUser = FirebaseAuth.instance;
  final productTitleController = TextEditingController();
  final productSubTitleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  List<String> imageList;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';
  var advertismentController = AdvertisementController();

  void initState() {
    super.initState();
    if (widget.advertisement != null) {
      priceController.text = widget.advertisement.price;
      descriptionController.text = widget.advertisement.description;
      productTitleController.text = widget.advertisement.title;
      productSubTitleController.text = widget.advertisement.subtitle;
    }
  }

  adEndDate() {
    return (DateTime.now().add(const Duration(days: 15)));
  }

  void handleUpdate() async {
    widget.advertisement.price = priceController.text;
    widget.advertisement.description = descriptionController.text;
    widget.advertisement.title = productTitleController.text;
    productSubTitleController.text = productSubTitleController.text;

    if (await advertismentController
        .updateAdvertisementAllField(widget.advertisement)) {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Successfully Added',
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

  void handleAdd() async {
    /*  widget.params['price'] = priceController.text;
    widget.params['title'] = productTitleController.text;
    widget.params['description'] = descriptionController.text;
    widget.params['condition'] = condition;
    widget.params['imageList'] = imageList;*/
    var advertisement = SpareAdvertisement(
        existingUser.currentUser.uid,
        false,
        false,
        DateTime.now().toString(),
        adEndDate().toString(),
        '0.00',
        priceController.text,
        descriptionController.text,
        productTitleController.text,
        productSubTitleController.text,
        imageList,
        '');

    var res = await advertismentController.addAdvertisment(
        existingUser.currentUser.uid, advertisement);
    if (res != null) {
      print("recent $res");
      List<String> imageList = await uploadFiles(images, res);
      await advertismentController.updateAdvertisement(
          existingUser.currentUser.uid, res, 'aId', res);
      print("imageList ${imageList}");
      if (await advertismentController.updateAdvertisement(
          existingUser.currentUser.uid, res, 'imageList', imageList)) {
        var params = {'adId': res, 'item': productTitleController.text};
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvertisementPaymentPage(params: params),
          ),
        );
      } else {
        //errpopup
      }
    } else {
      //error popup
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

  @override
  void dispose() {
    priceController.dispose();
    productTitleController.dispose();
    productSubTitleController.dispose();
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

  Future<String> downloadURL(String url) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(url)
        .getDownloadURL();
    return downloadURL;
  }

  Future<List<String>> uploadFiles(List<Asset> _images, String aid) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image, aid)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(Asset _image, String aid) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            '${existingUser.currentUser.uid}/advertisments/$aid/${_image.name}');

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
        maxImages: 1,
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
              controller: productSubTitleController,
              labelText: 'SubTitle *',
              hintText: "discount 5% offer",
              borderColor: AppColors.ash,
            ),
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
            SizedBox(height: size.height * 0.025),
            if (widget.advertisement == null)
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
            (widget.advertisement == null)
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
                          images.length == 0) {
                        fillRequiredFields();
                        return;
                      }
                      handleAdd();
                    },
                    isBold: true,
                  )
                : GenericButton(
                    textColor: AppColors.white,
                    backgroundColor: AppColors.Blue,
                    paddingVertical: 20,
                    paddingHorizontal: 80,
                    text: 'Update',
                    onPressed: () {
                      if (productTitleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          priceController.text.isEmpty ||
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
